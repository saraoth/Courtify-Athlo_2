import { GoogleGenAI } from "@google/genai";

export const getAIInstance = async () => {
  // Check for API key selection in shared app environment
  if (window.aistudio && !(await window.aistudio.hasSelectedApiKey())) {
    try {
      await window.aistudio.openSelectKey();
    } catch (e) {
      console.error("Failed to open API key selection dialog:", e);
    }
  }

  // Priority: 
  // 1. process.env.API_KEY (selected via dialog)
  // 2. process.env.GEMINI_API_KEY (set in environment)
  // 3. window.process?.env?.API_KEY (fallback for some environments)
  const apiKey = 
    (typeof process !== 'undefined' && process.env && typeof process.env.API_KEY === 'string' && process.env.API_KEY ? process.env.API_KEY : null) || 
    (typeof process !== 'undefined' && process.env && typeof process.env.GEMINI_API_KEY === 'string' && process.env.GEMINI_API_KEY ? process.env.GEMINI_API_KEY : null) || 
    (window as any).process?.env?.API_KEY || 
    (window as any).process?.env?.GEMINI_API_KEY ||
    (import.meta.env.VITE_API_KEY) ||
    (import.meta.env.VITE_GEMINI_API_KEY) ||
    "";
  
  if (!apiKey) {
    console.warn("No API key found. AI features may not work. Please ensure an API key is selected or set in the environment.");
  }

  return new GoogleGenAI({ apiKey: apiKey || "" });
};

export const getApiKey = () => {
  try {
    return process.env.API_KEY || process.env.GEMINI_API_KEY || import.meta.env.VITE_API_KEY || import.meta.env.VITE_GEMINI_API_KEY || "";
  } catch (e) {
    return import.meta.env.VITE_API_KEY || import.meta.env.VITE_GEMINI_API_KEY || "";
  }
};
