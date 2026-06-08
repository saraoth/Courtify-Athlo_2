import express from "express";
import { createServer as createViteServer } from "vite";
import path from "path";
import { fileURLToPath } from "url";
import admin from "firebase-admin";
import dotenv from "dotenv";
import fs from "fs";

/*
  ============================================================
  DART SERVER-SIDE SHELF BACKEND EQUIVALENT REFERENCE:
  ============================================================
  import 'dart:convert';
  import 'dart:io';
  import 'package:shelf/shelf.dart';
  import 'package:shelf/shelf_io.dart' as shelf_io;
  import 'package:shelf_router/shelf_router.dart';

  class DartServer {
    final Router _router = Router();

    DartServer() {
      _router.get('/api/health', (Request request) {
        return Response.ok(jsonEncode({'status': 'ok'}), headers: {'content-type': 'application/json'});
      });

      _router.get('/api/flutter-files', (Request request) {
        final dir = Directory('flutter_app');
        final files = dir.listSync(recursive: true)
            .whereType<File>()
            .map((f) => p.relative(f.path, from: 'flutter_app'))
            .toList();
        return Response.ok(jsonEncode({'files': files}), headers: {'content-type': 'application/json'});
      });

      _router.get('/api/flutter-file-content', (Request request) {
        final filePath = request.url.queryParameters['path'];
        if (filePath == null) return Response.badRequest(body: 'Path is required');
        final file = File('flutter_app/$filePath');
        return Response.ok(file.readAsStringSync(), headers: {'content-type': 'application/json'});
      });
    }

    Future<void> start() async {
      final handler = const Pipeline()
          .addMiddleware(logRequests())
          .addHandler(_router);
      final server = await shelf_io.serve(handler, '0.0.0.0', 3000);
      print('Dart Server online on port ${server.port}');
    }
  }
  ============================================================
*/

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function startServer() {
  const app = express();
  const PORT = 3000;

  // Initialize Firebase Admin
  // In this environment, we can usually initialize without explicit credentials
  // if running in a Google Cloud environment, but we'll try to be safe.
  try {
    admin.initializeApp({
      projectId: "courtify-athlo",
    });
    console.log("Firebase Admin initialized");
  } catch (error) {
    console.error("Firebase Admin initialization error:", error);
  }

  app.use(express.json());

  // API Route to send FCM notification
  app.post("/api/send-notification", async (req, res) => {
    const { token, title, body, data } = req.body;

    if (!token) {
      return res.status(400).json({ error: "Token is required" });
    }

    const message = {
      notification: {
        title,
        body,
      },
      data: data || {},
      token: token,
    };

    try {
      const response = await admin.messaging().send(message);
      console.log("Successfully sent message:", response);
      res.json({ success: true, response });
    } catch (error) {
      console.error("Error sending message:", error);
      res.status(500).json({ error: "Failed to send notification" });
    }
  });

  // Dynamic Flutter File List and Content serving API
  app.get("/api/flutter-files", (req, res) => {
    const getFiles = (dir: string, fileList: string[] = []) => {
      const fullPath = path.join(process.cwd(), dir);
      if (!fs.existsSync(fullPath)) return fileList;
      const files = fs.readdirSync(fullPath);
      files.forEach((file) => {
        const filePath = path.join(fullPath, file);
        const relPath = path.join(dir, file);
        if (fs.statSync(filePath).isDirectory()) {
          getFiles(relPath, fileList);
        } else {
          fileList.push(relPath);
        }
      });
      return fileList;
    };

    try {
      const files: string[] = [];
      if (fs.existsSync(path.join(process.cwd(), "pubspec.yaml"))) {
        files.push("pubspec.yaml");
      }
      getFiles("lib", files);
      res.json({ files });
    } catch (err) {
      console.error("Failed to read flutter folder:", err);
      res.status(500).json({ error: "Failed to list files" });
    }
  });

  app.get("/api/flutter-file-content", (req, res) => {
    const filePathStr = req.query.path as string;
    if (!filePathStr) return res.status(400).json({ error: "Path parameter is required" });

    try {
      const safeRelative = filePathStr.replace(/\.\./g, "");
      // Restrict file retrieval only to the Flutter scope files (lib/ and pubspec.yaml)
      if (safeRelative !== "pubspec.yaml" && !safeRelative.startsWith("lib/")) {
        return res.status(403).json({ error: "Access denied to requested file path context" });
      }
      const safePath = path.join(process.cwd(), safeRelative);
      if (fs.existsSync(safePath) && !fs.statSync(safePath).isDirectory()) {
        const content = fs.readFileSync(safePath, "utf8");
        res.json({ content });
      } else {
        res.status(404).json({ error: "File not found" });
      }
    } catch (err) {
      console.error("Failed to read file contents:", err);
      res.status(500).json({ error: "Failed to read file" });
    }
  });

  // API routes FIRST
  app.get("/api/health", (req, res) => {
    res.json({ status: "ok" });
  });

  // Vite middleware for development
  if (process.env.NODE_ENV !== "production") {
    const vite = await createViteServer({
      server: { middlewareMode: true },
      appType: "spa",
    });
    app.use(vite.middlewares);
  } else {
    const distPath = path.join(process.cwd(), 'dist');
    app.use(express.static(distPath));
    app.get('*', (req, res) => {
      res.sendFile(path.join(distPath, 'index.html'));
    });
  }

  app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server running on http://localhost:${PORT}`);
  });
}

startServer();
