import React, { useState, useEffect } from 'react';
import { onAuthStateChanged, User } from 'firebase/auth';
import { doc, getDoc, onSnapshot, setDoc } from 'firebase/firestore';
import { auth, db } from './firebase';
import { AnimatePresence, motion } from 'motion/react';
import { 
  AlertTriangle, 
  RefreshCcw, 
  FileCode, 
  Search, 
  Copy, 
  Check, 
  Phone, 
  Cpu, 
  Layers, 
  Download, 
  Sparkles,
  ArrowRight,
  BookOpen,
  Send,
  Mic,
  Video,
  Activity,
  Calendar,
  Users,
  Lock,
  Mail,
  UserCheck,
  TrendingUp,
  Settings,
  ChevronRight,
  LogOut,
  Sliders,
  DollarSign,
  Maximize2,
  Terminal,
  ShieldAlert,
  Play
} from 'lucide-react';
import { toast, Toaster } from 'sonner';

// Custom Type declarations matching Flutter structure
export type UserRole = 'player' | 'coach' | 'parent' | 'admin';

export interface UserProfile {
  uid: string;
  email: string;
  name: string;
  role: UserRole;
  avatar?: string;
  parentId?: string;
  sports?: string[];
  skillLevel?: string;
  availability?: string;
  onboardingCompleted?: boolean;
}

const App: React.FC = () => {
  // Authentication & Simulation States
  const [user, setUser] = useState<User | null>(null);
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const [loading, setLoading] = useState(true);

  // Flutter Simulator Screens states
  const [simActiveTab, setSimActiveTab] = useState<'home' | 'feature' | 'settings'>('home');
  const [simSelectedFeature, setSimSelectedFeature] = useState<'chat' | 'telecoach' | 'videolab' | 'performance' | 'booking' | null>(null);
  const [simLoading, setSimLoading] = useState(false);
  const [showDebugBanner, setShowDebugBanner] = useState(true);
  const [simOnboardingRole, setSimOnboardingRole] = useState<UserRole>('player');
  const [simOnboardingSports, setSimOnboardingSports] = useState<string[]>(['Tennis']);
  const [simOnboardingSkill, setSimOnboardingSkill] = useState<string>('Intermediate');

  // Input states inside simulation
  const [simEmail, setSimEmail] = useState('');
  const [simPassword, setSimPassword] = useState('');
  const [simName, setSimName] = useState('');
  const [simIsLogin, setSimIsLogin] = useState(true);
  const [simError, setSimError] = useState('');

  // Booking states
  const [simBookingDate, setSimBookingDate] = useState('2026-06-10');
  const [simBookingCourt, setSimBookingCourt] = useState('Supreme Court 1');
  const [simBookingTime, setSimBookingTime] = useState('10:00 AM');
  const [simMyBookings, setSimMyBookings] = useState<any[]>([
    { id: '1', date: '2026-06-08', court: 'Center Court 01', time: '02:00 PM', status: 'CONFIRMED' }
  ]);

  // Tele-Coach Waveform animation
  const [coachIsVoiceActive, setCoachIsVoiceActive] = useState(false);
  const [coachIsMuted, setCoachIsMuted] = useState(false);

  // Video generator values
  const [veoPrompt, setVeoPrompt] = useState('Top-spin backhand demonstration at 120 FPS slow motion with optical tracking...');
  const [veoGenerating, setVeoGenerating] = useState(false);
  const [veoVideoReady, setVeoVideoReady] = useState(false);

  // IDE states
  const [flutterFiles, setFlutterFiles] = useState<string[]>([]);
  const [selectedFile, setSelectedFile] = useState<string>('lib/main.dart');
  const [selectedCode, setSelectedCode] = useState<string>('');
  const [loadingCode, setLoadingCode] = useState(false);
  const [codeSearch, setCodeSearch] = useState('');
  const [copied, setCopied] = useState(false);
  const [activeWorkspaceView, setActiveWorkspaceView] = useState<'simulator' | 'code'>('simulator');
  const [consoleLogs, setConsoleLogs] = useState<string[]>([
    "Flutter Engine initialized. Device model: Web-Canvas (SDK v3.22.0)",
    "Canvaskit renderer compiled with WebGL hardware acceleration",
    "Firebase Firestore database synchronization active (elo_rankings)",
    "Security rules verification passed context successfully"
  ]);

  // Secure Chat states in Simulation
  const [chatChannels, setChatChannels] = useState<any[]>([
    {
      uid: 'coach_rob',
      name: 'Coach Robert',
      avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Robert',
      role: 'COACH',
      lastMessage: 'Ready for your spin analysis tomorrow?',
      lastTime: '10:42 AM',
      messages: [
        { role: 'assistant', text: 'Hi athlete, make sure to drink water and warm up.' },
        { role: 'user', text: 'Understood Coach! I improved my shoulder posture.' },
        { role: 'assistant', text: 'Ready for your spin analysis tomorrow?' },
      ]
    },
    {
      uid: 'opp_carlos',
      name: 'Carlos Alcaraz',
      avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Carlos',
      role: 'PLAYER',
      lastMessage: 'Awesome match! Can you book Supreme Court 02?',
      lastTime: 'Yesterday',
      messages: [
        { role: 'assistant', text: "Hey, let's schedule our league game." },
        { role: 'user', text: 'Sure, which court?' },
        { role: 'assistant', text: 'Awesome match! Can you book Supreme Court 02?' },
      ]
    }
  ]);
  const [activeChatUid, setActiveChatUid] = useState<string | null>(null);
  const [chatMessageInput, setChatMessageInput] = useState('');

  // Fetch Flutter codebase folders and files on mount
  useEffect(() => {
    const fetchFileList = async () => {
      try {
        const response = await fetch('/api/flutter-files');
        const data = await response.json();
        if (data.files) {
          setFlutterFiles(data.files);
        }
      } catch (err) {
        console.error("Failed to read flutter files directory structure:", err);
      }
    };
    fetchFileList();
  }, []);

  // Fetch file content when file selection changes
  useEffect(() => {
    const fetchContent = async () => {
      if (!selectedFile) return;
      setLoadingCode(true);
      try {
        const response = await fetch(`/api/flutter-file-content?path=${encodeURIComponent(selectedFile)}`);
        const data = await response.json();
        if (data.content) {
          setSelectedCode(data.content);
        } else {
          setSelectedCode('// Code content not found or error parsing.');
        }
      } catch (err) {
        setSelectedCode('// Server communication failure.');
      } finally {
        setLoadingCode(false);
      }
    };
    fetchContent();

    setConsoleLogs(prev => [
      ...prev,
      `[Dart SDK] Hot Loaded: ${selectedFile}`
    ].slice(-10));
  }, [selectedFile]);

  // Firebase auth synchronization
  useEffect(() => {
    const unsubscribeAuth = onAuthStateChanged(auth, async (currentUser) => {
      setUser(currentUser);
      if (currentUser) {
        try {
          const userDocRef = doc(db, 'users', currentUser.uid);
          const userDoc = await getDoc(userDocRef);
          
          if (userDoc.exists()) {
            setProfile(userDoc.data() as UserProfile);
          } else {
            // Setup a default initial profile
            const newProfile: UserProfile = {
              uid: currentUser.uid,
              email: currentUser.email || '',
              name: currentUser.displayName || currentUser.email?.split('@')[0] || 'Athlete',
              role: 'player',
              onboardingCompleted: false
            };
            setProfile(newProfile);
          }
        } catch (error: any) {
          console.error("Firestore auth sync failed:", error);
          toast.error("Firestore sync unavailable, falling back to local simulation.");
        }
      } else {
        setProfile(null);
      }
      setLoading(false);
    });

    return () => unsubscribeAuth();
  }, []);

  // Sync profile details if changed inside Firestore
  useEffect(() => {
    if (user) {
      const unsubscribeProfile = onSnapshot(doc(db, 'users', user.uid), (doc) => {
        if (doc.exists()) {
          setProfile(doc.data() as UserProfile);
        }
      });
      return () => unsubscribeProfile();
    }
  }, [user]);

  // Handler for simulated action logs
  const addConsoleLog = (log: string) => {
    setConsoleLogs(prev => [...prev, log].slice(-12));
  };

  // Mock Submit for Credentials / Register (Flutter Material styling mock)
  const handleSimulatedSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!simEmail || !simPassword) {
      setSimError("Please enter email & password credentials");
      return;
    }
    if (!simIsLogin && !simName) {
      setSimError("Please provide your display name");
      return;
    }

    setSimLoading(true);
    setSimError('');
    addConsoleLog(`[Material State] Dispatching Firebase Auth request for ${simEmail}`);

    try {
      await new Promise(resolve => setTimeout(resolve, 1200));
      // Construct profile configuration
      const fakeUID = `f_u_${Date.now()}`;
      const mockUserProfile: UserProfile = {
        uid: fakeUID,
        email: simEmail,
        name: simIsLogin ? simEmail.split('@')[0] : simName,
        role: simOnboardingRole,
        avatar: `https://api.dicebear.com/7.x/avataaars/svg?seed=${simEmail}`,
        onboardingCompleted: false,
      };

      // Set user simulator profile
      setUser({ uid: fakeUID, email: simEmail } as any);
      setProfile(mockUserProfile);
      addConsoleLog(`[Firestore Database] SetDoc successful on 'users/${fakeUID}'`);
      toast.success("Authenticating security payload successful!");
    } catch (e: any) {
      setSimError(e.message || "Failed authentication payload submission");
    } finally {
      setSimLoading(false);
    }
  };

  // Google SSO simulated sequence
  const handleSimulatedGoogleSSO = async () => {
    setSimLoading(true);
    addConsoleLog("[Google SSO] Directing browser popup context...");
    try {
      await new Promise(resolve => setTimeout(resolve, 1000));
      const fakeUID = 'g_999';
      const googleProfile: UserProfile = {
        uid: fakeUID,
        email: 'athlete.elite@gmail.com',
        name: 'Alex Rivera',
        role: 'player',
        avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Alex',
        onboardingCompleted: false
      };
      setUser({ uid: fakeUID, email: googleProfile.email } as any);
      setProfile(googleProfile);
      addConsoleLog("[Firestore Database] Synced Google oauth user in 'users/g_999'");
    } catch (err) {
      addConsoleLog("[Google SSO] Failed SSO sequence verification");
    } finally {
      setSimLoading(false);
    }
  };

  // Simulated Onboarding completion
  const handleOnboardingComplete = async () => {
    if (!profile) return;
    setSimLoading(true);
    addConsoleLog("[Flutter Router] Navigating to final onboarding step...");
    try {
      const updatedProfile: UserProfile = {
        ...profile,
        role: simOnboardingRole,
        sports: simOnboardingSports,
        skillLevel: simOnboardingSkill,
        onboardingCompleted: true
      };

      await new Promise(resolve => setTimeout(resolve, 1000));
      setProfile(updatedProfile);
      addConsoleLog(`[Material FormState] Saved profile parameters. Complete ELO baseline synchronized!`);
      toast.success("Onboarding fully successfully registered in Flutter!");
    } catch (err) {
      toast.error("Onboarding saving has encountered issues");
    } finally {
      setSimLoading(false);
    }
  };

  // Dynamic booking helper
  const handlePlaceBooking = () => {
    addConsoleLog(`[Cupertino Dialog] Submitting booking request logic...`);
    const newBook = {
      id: Date.now().toString(),
      date: simBookingDate,
      court: simBookingCourt,
      time: simBookingTime,
      status: 'CONFIRMED'
    };
    setSimMyBookings(prev => [newBook, ...prev]);
    toast.success(`Booking configured for ${simBookingCourt} on ${simBookingDate}`);
    addConsoleLog(`[Cloud Storage] Confirmed booking slot successfully registered: ${simBookingCourt}`);
    setSimSelectedFeature(null);
  };

  // Send message helper
  const handleSendChatMessage = () => {
    if (!chatMessageInput.trim() || !activeChatUid) return;
    
    // Add user message to current active chat
    setChatChannels(prev => prev.map(ch => {
      if (ch.uid === activeChatUid) {
        const updatedMsgs = [...ch.messages, { role: 'user', text: chatMessageInput }];
        return {
          ...ch,
          lastMessage: chatMessageInput,
          lastTime: 'Now',
          messages: updatedMsgs
        };
      }
      return ch;
    }));

    const messageToSend = chatMessageInput;
    setChatMessageInput('');
    addConsoleLog(`[Encryption Service] Transmitted secured messaging payload: "${messageToSend.substring(0, 20)}..."`);

    // Simulated automated responder delay
    setTimeout(() => {
      setChatChannels(prev => prev.map(ch => {
        if (ch.uid === activeChatUid) {
          const helperReplies = {
            'coach_rob': "Awesome racket acceleration! Let's examine your launch flight angles. Make sure to review the Veo technique video.",
            'opp_carlos': "That sounds fantastic! We can use court 1 for top spin rallies next. Catch you on the league court!"
          };
          const reply = helperReplies[activeChatUid as keyof typeof helperReplies] || "The coaching staff has been notified of your inquiry. Translating parameters...";
          return {
            ...ch,
            lastMessage: reply,
            lastTime: 'Now',
            messages: [...ch.messages, { role: 'assistant', text: reply }]
          };
        }
        return ch;
      }));
      addConsoleLog(`[Model Engine] Executed response prompt via remote assistant`);
    }, 1500);
  };

  // Video generator simulator
  const handleTriggerVeoVideo = () => {
    if (!veoPrompt.trim()) return;
    setVeoGenerating(true);
    addConsoleLog(`[Veo-3.1 Model] Starting video render pipeline for prompt: "${veoPrompt}"`);
    setTimeout(() => {
      setVeoGenerating(false);
      setVeoVideoReady(true);
      addConsoleLog(`[Veo-3.1 Model] Render complete! Ready 1080p stream from assets/mixkit`);
      toast.success("AI video demonstration successfully generated!");
    }, 2500);
  };

  const handleCopyCode = () => {
    navigator.clipboard.writeText(selectedCode);
    setCopied(true);
    toast.success("Dart source code copied directly!");
    setTimeout(() => setCopied(false), 2000);
  };

  // Code visual presentation
  const renderCodeViewer = (code: string) => {
    if (!code) return <span className="text-slate-500">// Select a file or loading...</span>;
    return code.split('\n').map((line, index) => {
      let isComment = line.trim().startsWith('//') || line.trim().startsWith('/*') || line.trim().startsWith('*');
      let inlineStyle = "text-slate-300";
      if (isComment) inlineStyle = "text-emerald-500 italic";
      
      // Highlight Dart keywords visually
      const words = line.split(/(\s+|\(|\)|\{|\}|\[|\]|;|,|\.|\'|\")/);
      const highlightedLine = words.map((word, wIdx) => {
        const keywords = [
          'import', 'class', 'extends', 'void', 'return', 'final', 'const', 'super', 
          'required', 'this', 'override', 'Widget', 'BuildContext', 'Map', 'List', 'String', 'bool', 
          'int', 'double', 'MaterialApp', 'Scaffold', 'StatefulWidget', 'StatelessWidget', 'State'
        ];
        if (keywords.includes(word)) {
          return <span key={wIdx} className="text-pink-400 font-bold">{word}</span>;
        } else if (word.startsWith('@')) {
          return <span key={wIdx} className="text-amber-300 italic">{word}</span>;
        } else if (word.match(/^\d+$/)) {
          return <span key={wIdx} className="text-cyan-400">{word}</span>;
        } else if (word.match(/^'[^']*'$/) || word.match(/^"[^"]*"$/)) {
          return <span key={wIdx} className="text-emerald-300 font-medium">{word}</span>;
        }
        return word;
      });

      return (
        <div key={index} className="flex">
          <span className="w-9 select-none text-right pr-4 text-slate-600 text-[10px] font-mono leading-5">{index + 1}</span>
          <span className="font-mono text-xs whitespace-pre pr-2 leading-5 tracking-wide leading-relaxed">{isComment ? <span className="text-emerald-500 italic">{line}</span> : highlightedLine}</span>
        </div>
      );
    });
  };

  // Render simulated screens inside our smartphone container block
  const renderSimulatedMobileApp = () => {
    if (simLoading) {
      return (
        <div className="flex-1 flex flex-col items-center justify-center bg-[#0F172A] p-6 text-white text-center">
          <div className="w-16 h-16 relative flex items-center justify-center">
            <div className="absolute inset-0 border-4 border-cyan-500/20 border-t-cyan-400 rounded-full animate-spin" />
            <Layers className="w-6 h-6 text-cyan-400" />
          </div>
          <p className="mt-6 text-xs font-black tracking-widest text-cyan-400 uppercase">FLUTTER CANVASKIT</p>
          <span className="text-[11px] text-slate-400 mt-1 block">Compiling UI nodes into canvas layers...</span>
        </div>
      );
    }

    if (!user) {
      // Flutter Sign-In/Register Screen mockup
      return (
        <div className="flex-1 flex flex-col bg-[#0F172A] text-white relative overflow-y-auto no-scrollbar">
          {/* Cover image styling with Overlay */}
          <div className="absolute top-0 inset-x-0 h-44 bg-gradient-to-b from-[#2F80ED]/30 via-[#2F80ED]/10 to-transparent pointer-events-none" />
          
          <div className="flex-1 flex flex-col justify-center p-6 pt-12 relative z-10">
            {/* Main Trophy Icon and Flutter Logo marker */}
            <div className="flex items-center justify-between mb-8">
              <div className="w-12 h-12 bg-gradient-to-tr from-blue-600 to-cyan-500 rounded-2xl flex items-center justify-center shadow-lg shadow-blue-500/20">
                <Play className="w-6 h-6 text-white ml-0.5" />
              </div>
              <div className="text-right">
                <span className="text-[9px] font-bold text-slate-400 tracking-widest bg-slate-800/80 px-2 py-0.5 rounded border border-slate-700/50">MD-3 PLATFORM</span>
              </div>
            </div>

            <h1 className="text-2xl font-extrabold tracking-tight text-white font-display">Courtify Athletic</h1>
            <p className="text-xs text-slate-400 mt-1">Immersive cross-platform biomechanics and smart training.</p>

            {simError && (
              <div className="mt-4 p-3 bg-rose-500/10 border border-rose-500/20 rounded-xl text-left flex items-start gap-2.5">
                <AlertTriangle className="w-4 h-4 text-rose-400 shrink-0 mt-0.5" />
                <p className="text-[11px] text-rose-300 font-medium leading-relaxed">{simError}</p>
              </div>
            )}

            <form onSubmit={handleSimulatedSubmit} className="mt-6 space-y-4">
              {!simIsLogin && (
                <div>
                  <label className="block text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1.5">DISPLAY NAME</label>
                  <div className="relative">
                    <input
                      type="text"
                      className="w-full bg-slate-900/80 border border-slate-800 rounded-xl py-3 px-4 pl-10 text-xs text-white focus:outline-none focus:border-blue-500 transition-all font-medium"
                      placeholder="e.g. Alex Rivera"
                      value={simName}
                      onChange={(e) => setSimName(e.target.value)}
                    />
                    <Users className="w-3.5 h-3.5 text-slate-500 absolute left-3.5 top-3.5" />
                  </div>
                </div>
              )}

              <div>
                <label className="block text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1.5">EMAIL ADRESS</label>
                <div className="relative">
                  <input
                    type="email"
                    className="w-full bg-slate-900/80 border border-slate-800 rounded-xl py-3 px-4 pl-10 text-xs text-white focus:outline-none focus:border-blue-500 transition-all font-medium"
                    placeholder="e.g. athlete.elite@gmail.com"
                    value={simEmail}
                    onChange={(e) => setSimEmail(e.target.value)}
                  />
                  <Mail className="w-3.5 h-3.5 text-slate-500 absolute left-3.5 top-3.5" />
                </div>
              </div>

              <div>
                <label className="block text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1.5">SECURE KEY PASSWORD</label>
                <div className="relative">
                  <input
                    type="password"
                    className="w-full bg-slate-900/80 border border-slate-800 rounded-xl py-3 px-4 pl-10 text-xs text-white focus:outline-none focus:border-blue-500 transition-all font-medium"
                    placeholder="••••••••"
                    value={simPassword}
                    onChange={(e) => setSimPassword(e.target.value)}
                  />
                  <Lock className="w-3.5 h-3.5 text-slate-500 absolute left-3.5 top-3.5" />
                </div>
              </div>

              {/* Submit button mimicking Material Design Elevated button */}
              <button
                type="submit"
                className="w-full py-3.5 mt-4 bg-blue-600 hover:bg-blue-500 rounded-xl text-xs font-black tracking-wider text-white shadow-lg shadow-blue-500/20 active:scale-[0.98] transition-all flex items-center justify-center gap-2"
              >
                {simIsLogin ? 'SIGN IN DEPLOY' : 'ENGAGE PERFORMANCE CORE'}
                <ArrowRight className="w-4 h-4" />
              </button>
            </form>

            <div className="relative my-6 flex items-center justify-center">
              <div className="absolute inset-x-0 h-px bg-slate-800" />
              <span className="relative bg-[#0F172A] px-3 text-[10px] font-extrabold text-slate-500 tracking-widest">OR</span>
            </div>

            <button
              onClick={handleSimulatedGoogleSSO}
              className="w-full py-3 bg-slate-900 hover:bg-slate-850 border border-slate-800 rounded-xl text-xs font-bold text-white transition-all flex items-center justify-center gap-2 active:scale-[0.98]"
            >
              <div className="w-4.5 h-4.5 bg-white rounded-full flex items-center justify-center mr-0.5">
                <span className="text-[10px] font-black text-[#FBBC05]">G</span>
              </div>
              Continue via Google Accounts
            </button>

            <button
              onClick={() => setSimIsLogin(!simIsLogin)}
              className="mt-6 text-center text-[11px] font-bold text-blue-400 hover:underline"
            >
              {simIsLogin ? "New to Athlo? Deploy Elite Workspace profile" : "Have existing accounts? Sign In"}
            </button>
          </div>
        </div>
      );
    }

    if (profile && !profile.onboardingCompleted) {
      // Flutter Role Selection Onboarding Screen Mockup
      return (
        <div className="flex-1 flex flex-col bg-[#0F172A] text-white p-6 justify-between select-none">
          <div className="pt-6">
            <span className="text-[10px] font-black tracking-widest text-[#2F80ED] uppercase block">BASELINE SETUP</span>
            <h1 className="text-xl font-extrabold text-white mt-1">Calibrate Core Role</h1>
            <p className="text-[11px] text-slate-400 mt-1">Configure your profile parameters to define active sports dashboards.</p>

            {/* Simulated Grid of Radio Buttons */}
            <div className="mt-6 space-y-3">
              <label className="block text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-1">SELECT SPORT WORKSPACE</label>
              <div className="grid grid-cols-2 gap-2">
                {[
                  { name: 'Tennis', icon: '🎾' },
                  { name: 'Squash', icon: '🏸' },
                  { name: 'Squash Padel', icon: '🏸' },
                  { name: 'General Club', icon: '🏛️' }
                ].map((sp) => {
                  const sel = simOnboardingSports.includes(sp.name);
                  return (
                    <button
                      key={sp.name}
                      onClick={() => {
                        setSimOnboardingSports(prev => 
                          prev.includes(sp.name) ? prev.filter(p => p !== sp.name) : [...prev, sp.name]
                        );
                      }}
                      className={`p-3 text-left rounded-xl transition-all border flex items-center gap-2 ${sel ? 'bg-blue-600/10 border-blue-500 text-white' : 'bg-slate-900/60 border-slate-800 text-slate-400'}`}
                    >
                      <span className="text-sm">{sp.icon}</span>
                      <span className="text-xs font-bold leading-none">{sp.name}</span>
                    </button>
                  );
                })}
              </div>
            </div>

            {/* Target Role selection panel */}
            <div className="mt-6">
              <label className="block text-[10px] font-bold text-slate-400 tracking-widest mb-2 uppercase">SELECT SYSTEM PRIVILEGES ROLE</label>
              <div className="grid grid-cols-2 gap-2">
                {[
                  { id: 'player', name: 'Elite Player', desc: 'Core biomechanics' },
                  { id: 'coach', name: 'Club Coach', desc: 'Live coaching telemetry' },
                  { id: 'parent', name: 'Parent Sync', desc: 'Secure billing & logs' },
                  { id: 'admin', name: 'Club Administrator', desc: 'Court reservation matrix' }
                ].map((rl) => {
                  const sel = simOnboardingRole === rl.id;
                  return (
                    <button
                      key={rl.id}
                      onClick={() => setSimOnboardingRole(rl.id as UserRole)}
                      className={`p-3 text-left rounded-xl border transition-all ${sel ? 'bg-blue-600/10 border-blue-500 text-white' : 'bg-slate-900/50 border-slate-800 text-slate-400'}`}
                    >
                      <span className="text-xs font-bold block">{rl.name}</span>
                      <span className="text-[10px] text-slate-400 font-medium leading-none mt-1 block">{rl.desc}</span>
                    </button>
                  );
                })}
              </div>
            </div>

            {/* Slider experience picker */}
            <div className="mt-6">
              <label className="block text-[10px] font-bold text-slate-400 tracking-widest uppercase mb-1">SKILL CLASSIFICATION</label>
              <div className="flex gap-2">
                {['Introductory', 'Intermediate', 'Advanced', 'Tournament Elite'].map((level) => (
                  <button
                    key={level}
                    onClick={() => setSimOnboardingSkill(level)}
                    className={`flex-1 py-1.5 px-1 rounded-lg text-[9px] font-bold text-center border capitalize transition-all ${simOnboardingSkill === level ? 'bg-cyan-500/10 border-cyan-500 text-cyan-400' : 'bg-slate-900/50 border-slate-850 text-slate-500'}`}
                  >
                    {level.split(' ')[0]}
                  </button>
                ))}
              </div>
            </div>
          </div>

          <div className="pt-6">
            <button
              onClick={handleOnboardingComplete}
              className="w-full py-3.5 bg-blue-600 hover:bg-blue-500 rounded-xl text-xs font-black tracking-wider text-white shadow-lg shadow-blue-500/20 active:scale-[0.98] transition-all flex items-center justify-center gap-2"
            >
              INITIALIZE FLUTTER FLIGHT PATH
              <ArrowRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      );
    }

    // Interactive Flutter Feature Modal Windows
    if (simSelectedFeature) {
      return (
        <div className="flex-1 flex flex-col bg-[#0F172A] text-white">
          {/* Modal Header */}
          <div className="p-4 bg-slate-900 border-b border-slate-800 flex items-center justify-between">
            <button 
              onClick={() => {
                setSimSelectedFeature(null);
                setCoachIsVoiceActive(false);
              }}
              className="px-3 py-1.5 bg-slate-800 hover:bg-slate-750 text-xs font-bold rounded-lg text-slate-300"
            >
              Back
            </button>
            <span className="text-xs font-black tracking-widest text-[#2F80ED] uppercase flex items-center gap-1.5">
              <Sparkles className="w-3.5 h-3.5 text-cyan-400 animate-pulse" />
              FLUTTER ENGINE DIALOG
            </span>
            <div className="w-8" />
          </div>

          <div className="flex-1 overflow-y-auto no-scrollbar">
            {/* Feature View: Chat */}
            {simSelectedFeature === 'chat' && (
              <div className="h-full flex flex-col">
                {activeChatUid ? (
                  // Active Chat dialog box
                  <div className="flex-1 flex flex-col justify-between bg-slate-950">
                    <div className="p-3 bg-slate-900 border-b border-slate-800 flex items-center justify-between">
                      <div className="flex items-center gap-2.5">
                        <img 
                          src={chatChannels.find(c => c.uid === activeChatUid)?.avatar} 
                          className="w-8 h-8 rounded-full border border-slate-700 bg-slate-800" 
                          alt="" 
                        />
                        <div>
                          <span className="text-xs font-bold text-white block">{chatChannels.find(c => c.uid === activeChatUid)?.name}</span>
                          <span className="text-[9px] text-emerald-400 font-bold block flex items-center gap-1">
                            <span className="w-1.5 h-1.5 rounded-full bg-emerald-500" />
                            Active Stream Secure
                          </span>
                        </div>
                      </div>
                      <button 
                        onClick={() => setActiveChatUid(null)}
                        className="text-[10px] font-bold text-[#F2994A] hover:underline"
                      >
                        Channels List
                      </button>
                    </div>

                    {/* Messages thread list */}
                    <div className="flex-1 p-4 overflow-y-auto space-y-3">
                      {chatChannels.find(c => c.uid === activeChatUid)?.messages.map((m: any, idx: number) => {
                        const isUser = m.role === 'user';
                        return (
                          <div key={idx} className={`flex ${isUser ? 'justify-end' : 'justify-start'}`}>
                            <div className={`max-w-[80%] p-3 rounded-2xl text-[11px] leading-relaxed shadow-sm ${isUser ? 'bg-blue-600 text-white rounded-tr-none' : 'bg-slate-900 text-slate-100 border border-slate-800 rounded-tl-none'}`}>
                              {m.text}
                            </div>
                          </div>
                        );
                      })}
                    </div>

                    {/* Send Message controls bar */}
                    <div className="p-3 bg-slate-900 border-t border-slate-850 flex gap-2">
                      <input 
                        type="text" 
                        value={chatMessageInput}
                        onChange={(e) => setChatMessageInput(e.target.value)}
                        className="flex-1 bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-xs text-white focus:outline-none focus:border-blue-500 font-medium"
                        placeholder="Type encrypted message payload..."
                        onKeyDown={(e) => {
                          if (e.key === 'Enter') handleSendChatMessage();
                        }}
                      />
                      <button 
                        onClick={handleSendChatMessage}
                        className="p-2 bg-blue-600 hover:bg-blue-500 text-white rounded-xl active:scale-95 transition-all"
                      >
                        <Send className="w-4 h-4" />
                      </button>
                    </div>
                  </div>
                ) : (
                  // Channels listing
                  <div className="p-4 space-y-3">
                    <span className="text-[10px] font-black tracking-widest text-[#2F80ED] uppercase block mb-2">DIALOG CHANNELS</span>
                    {chatChannels.map((c) => (
                      <div 
                        key={c.uid}
                        onClick={() => setActiveChatUid(c.uid)}
                        className="bg-slate-900/60 hover:bg-slate-900 border border-slate-850 hover:border-slate-800 rounded-2xl p-3.5 cursor-pointer transition-all flex items-center justify-between"
                      >
                        <div className="flex items-center gap-3">
                          <img src={c.avatar} className="w-10 h-10 rounded-full border border-slate-700 bg-slate-800" alt="" />
                          <div>
                            <div className="flex items-center gap-1.5">
                              <span className="text-xs font-bold text-white block">{c.name}</span>
                              <span className="px-1.5 py-0.5 rounded bg-blue-500/10 text-[#2F80ED] text-[7px] font-black tracking-widest">{c.role}</span>
                            </div>
                            <span className="text-[10px] text-slate-400 mt-1 block max-w-[150px] truncate">{c.lastMessage}</span>
                          </div>
                        </div>
                        <div className="text-right flex flex-col justify-between items-end h-8">
                          <span className="text-[9px] text-slate-500 font-bold">{c.lastTime}</span>
                          <span className="w-2 h-2 rounded-full bg-[#2F80ED]" />
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            )}

            {/* Feature View: AI Telecoach (Waveform) */}
            {simSelectedFeature === 'telecoach' && (
              <div className="p-6 text-center flex flex-col justify-between h-full min-h-[350px]">
                <div className="text-center">
                  <div className="w-12 h-12 bg-indigo-500/10 border border-indigo-500/20 rounded-2xl flex items-center justify-center mx-auto mb-4">
                    <Phone className="w-6 h-6 text-indigo-400" />
                  </div>
                  <h2 className="text-base font-extrabold text-white">AI Voice Tele-Coach</h2>
                  <p className="text-[11px] text-slate-400 mt-1 max-w-xs mx-auto leading-relaxed">
                    A multi-modal Gemini voice session to direct racquet and launch dynamics on court in real time.
                  </p>
                </div>

                {/* Animated wave form */}
                <div className="my-8 flex items-center justify-center gap-1.5 h-16 relative">
                  {coachIsVoiceActive ? (
                    Array.from({ length: 15 }).map((_, i) => (
                      <motion.div 
                        key={i}
                        animate={{ height: [12, Math.random() * 56 + 10, 12] }}
                        transition={{ duration: 0.6 + i * 0.05, repeat: Infinity, ease: 'easeInOut' }}
                        className="w-1 bg-gradient-to-t from-blue-600 to-cyan-400 rounded-full"
                        style={{ height: 20 }}
                      />
                    ))
                  ) : (
                    <div className="absolute inset-0 flex items-center justify-center">
                      <span className="text-[10px] font-bold text-slate-500 tracking-wider uppercase bg-slate-900 border border-slate-850 px-3 py-1 rounded-full">Channel Standby</span>
                    </div>
                  )}
                </div>

                <div className="my-3 text-center">
                  <span className="text-[11px] font-semibold text-slate-300 italic block leading-relaxed max-w-xs mx-auto">
                    {coachIsVoiceActive 
                      ? '"Keep your racquet head high Alex! Accelerate your wrist rotation for increased court spin."' 
                      : 'Tap the micro toggle below to establish a real-time smart link.'
                    }
                  </span>
                </div>

                {/* Control Panel Buttons */}
                <div className="mt-6 flex justify-center gap-4">
                  <button 
                    onClick={() => setCoachIsMuted(!coachIsMuted)}
                    disabled={!coachIsVoiceActive}
                    className={`p-3 rounded-full border transition-all ${coachIsMuted ? 'bg-rose-600/15 border-rose-500 text-rose-400' : 'bg-slate-900 border-slate-800 text-slate-400'}`}
                  >
                    <Mic className="w-5 h-5" />
                  </button>
                  <button 
                    onClick={() => {
                      setCoachIsVoiceActive(!coachIsVoiceActive);
                      addConsoleLog(coachIsVoiceActive ? "[Tele-Coach] Closed channel session" : "[Tele-Coach] Connecting Gemini Multimodal Session...");
                    }}
                    className={`px-8 py-3.5 rounded-full text-xs font-black tracking-widest text-white shadow-md active:scale-95 transition-all ${coachIsVoiceActive ? 'bg-rose-600 shadow-rose-600/10' : 'bg-blue-600 shadow-blue-600/15'}`}
                  >
                    {coachIsVoiceActive ? 'DISCONNECT' : 'ESTABLISH AUDIO LINK'}
                  </button>
                </div>
              </div>
            )}

            {/* Feature View: AI Video Technique lab */}
            {simSelectedFeature === 'videolab' && (
              <div className="p-5">
                <span className="text-[10px] font-black tracking-widest text-cyan-400 uppercase block mb-1">VEO-3.1 VIDEO GENERATION</span>
                <h2 className="text-base font-extrabold text-white">Technique Generator</h2>
                <p className="text-[11px] text-slate-400 mt-0.5">Synthesize slow-motion high-fidelity technique representations.</p>

                <div className="mt-5 space-y-4">
                  <div>
                    <label className="block text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-1.5">Describe Movement Demonstration</label>
                    <textarea 
                      value={veoPrompt}
                      onChange={(e) => setVeoPrompt(e.target.value)}
                      rows={3}
                      className="w-full bg-slate-950 border border-slate-850 rounded-xl p-3 text-xs text-white focus:outline-none focus:border-cyan-500 font-medium leading-relaxed"
                      placeholder="Input description of rally, forehand, slice..."
                    />
                  </div>

                  <button 
                    onClick={handleTriggerVeoVideo}
                    disabled={veoGenerating}
                    className="w-full py-4 text-xs font-black tracking-wider bg-gradient-to-r from-blue-600 to-indigo-600 rounded-xl text-white shadow-lg active:scale-95 transition-all flex items-center justify-center gap-2"
                  >
                    {veoGenerating ? (
                      <>
                        <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                        RENDERING OPTICAL GRAPHICS...
                      </>
                    ) : (
                      <>
                        <Video className="w-4 h-4" />
                        COMPILE VEO TECHNIQUE
                      </>
                    )}
                  </button>

                  {/* Render simulated video presentation card */}
                  {(veoGenerating || veoVideoReady) && (
                    <div className="mt-5 aspect-video bg-black rounded-2xl border border-slate-800 overflow-hidden relative flex flex-col justify-center items-center text-center">
                      {veoGenerating ? (
                        <div className="p-4 space-y-2">
                          <Activity className="w-6 h-6 text-cyan-400 animate-pulse mx-auto" />
                          <span className="text-[10px] text-slate-400 font-bold tracking-widest block uppercase">DECODING VECTORS</span>
                        </div>
                      ) : (
                        <>
                          <img 
                            src="https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?q=80&w=600&auto=format&fit=crop" 
                            className="w-full h-full object-cover absolute inset-0 opacity-40" 
                            alt="" 
                          />
                          <div className="relative z-10 p-4">
                            <div className="w-10 h-10 bg-cyan-500 rounded-full flex items-center justify-center mx-auto mb-2 text-white shadow shadow-cyan-500/20 active:scale-90 transition-transform cursor-pointer">
                              <Play className="w-5.5 h-5.5 ml-0.5" />
                            </div>
                            <span className="text-xs font-black text-white block">Forehand Top Spin Model</span>
                            <span className="text-[9px] text-cyan-400 font-bold block mt-1 tracking-wider uppercase">120 FPS AUDIO DEMO READY</span>
                          </div>
                        </>
                      )}
                    </div>
                  )}
                </div>
              </div>
            )}

            {/* Feature View: AI Biomechanical Performance charts */}
            {simSelectedFeature === 'performance' && (
              <div className="p-4 space-y-5">
                <div>
                  <span className="text-[10px] font-black tracking-widest text-[#2F80ED] uppercase block">BIOMETRIC INSIGHTS</span>
                  <h2 className="text-base font-extrabold text-white mt-1">Spin and Speed Telemetry</h2>
                  <p className="text-[11px] text-slate-400 leading-snug">Real-time parameters verified by Gemini multi-modal scanning on court.</p>
                </div>

                {/* Simulated telemetry grids */}
                <div className="grid grid-cols-2 gap-3">
                  {[
                    { label: 'TOP-SPIN VELOCITY', val: '2,840 RPM', change: '+24%', color: 'text-indigo-400' },
                    { label: 'RACQUET SPEED', val: '86 MPH', change: '+4.2%', color: 'text-cyan-400' },
                    { label: 'ACCELERATION ANGLE', val: '42.6°', change: '+1.5°', color: 'text-emerald-400' },
                    { label: 'COURT INTEGRITY ELO', val: '1,720 pts', change: '+45 pts', color: 'text-amber-400' }
                  ].map((stat) => (
                    <div key={stat.label} className="bg-slate-900 border border-slate-850 p-3.5 rounded-2xl flex flex-col justify-between">
                      <span className="text-[8px] font-bold text-slate-500 tracking-wider block">{stat.label}</span>
                      <span className={`text-base font-extrabold mt-1.5 ${stat.color}`}>{stat.val}</span>
                      <span className="text-[9px] text-emerald-400 mt-1 font-bold">▲ {stat.change} delta</span>
                    </div>
                  ))}
                </div>

                {/* Progress bar and chart visualization mockup via pure nested HTML styles */}
                <div className="bg-slate-900 border border-slate-850 rounded-2xl p-4">
                  <span className="text-[9px] font-bold text-slate-400 uppercase tracking-widest block mb-3">BIOMEHCHANICS BREAKDOWN</span>
                  <div className="space-y-3 font-semibold">
                    {[
                      { name: 'Forehand Consistency', pct: 88, color: 'bg-emerald-500' },
                      { name: 'Backhand Net Clearance', pct: 74, color: 'bg-blue-500' },
                      { name: 'Service Pronation Speed', pct: 62, color: 'bg-indigo-500' }
                    ].map((m) => (
                      <div key={m.name} className="space-y-1">
                        <div className="flex justify-between text-[10px] text-slate-300">
                          <span>{m.name}</span>
                          <span>{m.pct}%</span>
                        </div>
                        <div className="h-1.5 bg-slate-950 rounded-full overflow-hidden">
                          <div className={`h-full ${m.color}`} style={{ width: `${m.pct}%` }} />
                        </div>
                      </div>
                    ))}
                  </div>
                </div>

                <div className="bg-[#2F80ED]/5 border border-[#2F80ED]/15 p-3 rounded-2xl">
                  <span className="text-[9.5px] font-black text-[#2F80ED] tracking-widest block uppercase">ATHLETE ACTION FEEDBACK</span>
                  <p className="text-[10px] text-slate-300 leading-relaxed mt-1.5">
                    "Alex's follow-through clearances on the backhand slice show high stability metrics compared to baseline standards. Work on wrist rigidity during launch phases."
                  </p>
                </div>
              </div>
            )}

            {/* Feature View: Booking Platform */}
            {simSelectedFeature === 'booking' && (
              <div className="p-5 space-y-4">
                <div>
                  <span className="text-[10px] font-black tracking-widest text-[#2F80ED] uppercase block">RESERVATION MODULE</span>
                  <h2 className="text-base font-extrabold text-white mt-0.5">Reserve Smart Court</h2>
                  <p className="text-[11px] text-slate-400">Lock secure slots in any active club court venue.</p>
                </div>

                <div className="space-y-3 text-xs">
                  <div>
                    <label className="block text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-1.5">CHOOSE COURT VENTURE</label>
                    <select 
                      value={simBookingCourt}
                      onChange={(e) => setSimBookingCourt(e.target.value)}
                      className="w-full bg-slate-950 border border-slate-850 rounded-xl py-2 px-3 text-xs text-white focus:outline-none focus:border-blue-500 font-bold"
                    >
                      <option>Supreme Court 1</option>
                      <option>Supreme Court 2</option>
                      <option>Interactive Clay 03</option>
                      <option>Championship Grass 01</option>
                    </select>
                  </div>

                  <div>
                    <label className="block text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-1.5">CHOOSE DATE</label>
                    <input 
                      type="date"
                      value={simBookingDate}
                      onChange={(e) => setSimBookingDate(e.target.value)}
                      className="w-full bg-slate-950 border border-slate-850 rounded-xl py-2 px-3 text-xs text-white focus:outline-none focus:border-blue-500 font-bold"
                    />
                  </div>

                  <div>
                    <label className="block text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-1.5">CHOOSE SESSION STAGE TIME</label>
                    <select 
                      value={simBookingTime}
                      onChange={(e) => setSimBookingTime(e.target.value)}
                      className="w-full bg-slate-950 border border-slate-850 rounded-xl py-2 px-3 text-xs text-white focus:outline-none focus:border-blue-500 font-bold"
                    >
                      <option>08:00 AM</option>
                      <option>10:00 AM</option>
                      <option>02:00 PM</option>
                      <option>04:00 PM</option>
                      <option>06:00 PM</option>
                    </select>
                  </div>

                  <button 
                    onClick={handlePlaceBooking}
                    className="w-full py-3.5 bg-blue-600 hover:bg-blue-500 text-white rounded-xl text-xs font-black tracking-wider transition-all shadow-lg text-center active:scale-95 flex items-center justify-center gap-1"
                  >
                    CONFIRM RESERVATION SLOT
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>
      );
    }

    if (!profile) {
      return (
        <div className="flex-1 flex flex-col items-center justify-center bg-[#0F172A] text-white p-6">
          <div className="w-8 h-8 border-4 border-blue-500 border-t-transparent rounded-full animate-spin" />
        </div>
      );
    }

    // Main authenticated Dashboards corresponding to Roles
    return (
      <div className="flex-1 flex flex-col bg-[#0F172A] text-white">
        
        {/* App Bar standard Flutter Material Header */}
        <div className="p-4 bg-slate-900 border-b border-slate-850 flex items-center justify-between shadow-md">
          <div className="flex items-center gap-2.5">
            <img 
              src={profile.avatar || `https://api.dicebear.com/7.x/avataaars/svg?seed=${profile.email}`} 
              className="w-8.5 h-8.5 rounded-full border border-slate-705 bg-slate-850" 
              alt="Avatar" 
            />
            <div>
              <span className="text-xs font-black text-white block leading-tight">{profile.name}</span>
              <span className="text-[10px] text-slate-400 select-none block leading-none flex items-center gap-1 mt-0.5 font-bold uppercase tracking-wider">
                <span className="w-1.5 h-1.5 rounded-full bg-cyan-400 animate-pulse" />
                {profile.role} CORE
              </span>
            </div>
          </div>

          <button 
            onClick={() => {
              setUser(null);
              setProfile(null);
              addConsoleLog("[Firebase Auth] Logout broadcast success");
            }}
            className="p-1.5 bg-slate-800 hover:bg-rose-500/10 hover:text-rose-400 text-slate-400 rounded-lg transition-all"
            title="Terminate active simulator session"
          >
            <LogOut className="w-3.5 h-3.5" />
          </button>
        </div>

        {/* Dashboard Body Content */}
        <div className="flex-1 overflow-y-auto p-4 space-y-4 select-none no-scrollbar pb-16">
          
          {/* Dashboard View: Player role */}
          {profile.role === 'player' && (
            <>
              {/* ELO Platform rating card */}
              <div className="bg-gradient-to-br from-indigo-900 to-slate-900 border border-indigo-500/10 rounded-2xl p-4 relative overflow-hidden">
                <div className="absolute right-0 bottom-0 opacity-10">
                  <TrendingUp className="w-24 h-24 text-white" />
                </div>
                <span className="text-[9px] font-black text-cyan-400 tracking-wider block uppercase">CURRENT LEVEL Baseline ELO</span>
                <span className="text-2xl font-black text-white mt-1.5 block">1,840 <span className="text-xs text-emerald-400 font-extrabold font-mono">▲ (Rank Tier A)</span></span>
                <p className="text-[11px] text-slate-350 leading-snug mt-1.5 font-medium">Clearance integrity is synced with global tennis indices parameters.</p>
              </div>

              {/* Grid of features */}
              <div className="grid grid-cols-2 gap-3">
                <button 
                  onClick={() => { setSimSelectedFeature('chat'); addConsoleLog("[Navigation] Router pushing chat_screen.dart"); }}
                  className="p-3.5 text-left bg-[#1B294A]/25 hover:bg-[#1B294A]/40 border border-slate-800 rounded-2xl transition-all cursor-pointer flex flex-col justify-between aspect-[1.3]"
                >
                  <Send className="w-5 h-5 text-indigo-400" />
                  <div>
                    <span className="text-xs font-bold text-white block">Secure Chat</span>
                    <span className="text-[9px] text-slate-400 mt-0.5 block leading-none">Opponents & Coaches</span>
                  </div>
                </button>

                <button 
                  onClick={() => { setSimSelectedFeature('telecoach'); addConsoleLog("[Navigation] Router pushing live_coach_screen.dart"); }}
                  className="p-3.5 text-left bg-[#1B294A]/25 hover:bg-[#1B294A]/40 border border-slate-800 rounded-2xl transition-all cursor-pointer flex flex-col justify-between aspect-[1.3]"
                >
                  <Phone className="w-5 h-5 text-cyan-400" />
                  <div>
                    <span className="text-xs font-bold text-white block">Live Coach</span>
                    <span className="text-[9px] text-slate-400 mt-0.5 block leading-none">Real-time biomechanics</span>
                  </div>
                </button>

                <button 
                  onClick={() => { setSimSelectedFeature('videolab'); addConsoleLog("[Navigation] Router pushing video_generator_screen.dart"); }}
                  className="p-3.5 text-left bg-[#1B294A]/25 hover:bg-[#1B294A]/40 border border-slate-800 rounded-2xl transition-all cursor-pointer flex flex-col justify-between aspect-[1.3]"
                >
                  <Video className="w-5 h-5 text-pink-400" />
                  <div>
                    <span className="text-xs font-bold text-white block">Video Lab</span>
                    <span className="text-[9px] text-slate-400 mt-0.5 block leading-none">Veo slow-motion demo</span>
                  </div>
                </button>

                <button 
                  onClick={() => { setSimSelectedFeature('performance'); addConsoleLog("[Navigation] Router pushing ai_insights_screen.dart"); }}
                  className="p-3.5 text-left bg-[#1B294A]/25 hover:bg-[#1B294A]/40 border border-slate-800 rounded-2xl transition-all cursor-pointer flex flex-col justify-between aspect-[1.3]"
                >
                  <Activity className="w-5 h-5 text-amber-400" />
                  <div>
                    <span className="text-xs font-bold text-white block">AI Metrics</span>
                    <span className="text-[9px] text-slate-400 mt-0.5 block leading-none">Telemetry highlights</span>
                  </div>
                </button>
              </div>

              {/* Bottom Reservation trigger */}
              <div className="bg-slate-900 border border-slate-850 p-4 rounded-2xl flex items-center justify-between">
                <div>
                  <span className="text-xs font-bold text-white block">Subjugate Reservation Slot</span>
                  <p className="text-[10px] text-slate-400 mt-0.5">Quick book court clay/grass matches.</p>
                </div>
                <button 
                  onClick={() => { setSimSelectedFeature('booking'); addConsoleLog("[Navigation] Router pushing booking_screen.dart"); }}
                  className="p-2 bg-blue-600 hover:bg-blue-500 rounded-xl text-xs font-bold text-white active:scale-95 transition-all text-center flex items-center gap-1"
                >
                  <Calendar className="w-4 h-4" />
                  Book
                </button>
              </div>
            </>
          )}

          {/* Dashboard View: Coach role */}
          {profile.role === 'coach' && (
            <>
              {/* Coach ELO Performance stats metrics */}
              <div className="bg-gradient-to-br from-indigo-950 to-slate-900 border border-indigo-500/10 p-4 rounded-2xl relative overflow-hidden">
                <span className="text-[9px] font-black text-indigo-400 tracking-wider uppercase block">ACTIVE CLIENT ROSTER</span>
                <span className="text-2xl font-black text-white block mt-1">14 Coached Athletes</span>
                <p className="text-[11px] text-slate-400 leading-snug mt-1 inline-block">Direct tracking logs are evaluated by biometric models.</p>
              </div>

              {/* Coach Action features Grid */}
              <div className="grid grid-cols-2 gap-3">
                <button 
                  onClick={() => { setSimSelectedFeature('chat'); addConsoleLog("[Navigation] Pushed coach secure communication channel"); }}
                  className="p-3.5 text-left bg-slate-900 border border-slate-850 rounded-2xl transition-all"
                >
                  <Send className="w-5 h-5 text-indigo-400 mb-4" />
                  <span className="text-xs font-bold text-white block">Secure Messenger</span>
                  <span className="text-[9px] text-slate-500 mt-1 block">Roster messages</span>
                </button>

                <button 
                  onClick={() => { setSimSelectedFeature('telecoach'); addConsoleLog("[Navigation] Initiating voice server port on live_coach"); }}
                  className="p-3.5 text-left bg-slate-900 border border-slate-850 rounded-2xl transition-all"
                >
                  <Phone className="w-5 h-5 text-cyan-400 mb-4" />
                  <span className="text-xs font-bold text-white block">Active Voice Sync</span>
                  <span className="text-[9px] text-slate-500 mt-1 block">Live voice feedback</span>
                </button>
              </div>

              {/* Athletes roster listings */}
              <div className="bg-slate-900 border border-slate-850 rounded-2xl p-4">
                <span className="text-[9px] font-bold text-slate-400 block mb-3 uppercase tracking-widest">ACTIVE ATHLETE FEED</span>
                <div className="space-y-3">
                  {[
                    { name: 'Alex Rivera', sport: 'Tennis Singlet', status: 'Slices review needed', e: '1,840 pts' },
                    { name: 'Carlos Alcaraz', sport: 'Touring Padel', status: 'Matches complete', e: '2,510 pts' }
                  ].map((at) => (
                    <div key={at.name} className="flex justify-between items-center border-b border-slate-850 pb-2 bg-slate-950/20 px-2 py-1 rounded-xl">
                      <div>
                        <span className="text-xs font-bold text-white block">{at.name}</span>
                        <span className="text-[9px] text-slate-500 mt-0.5 block">{at.sport} • {at.status}</span>
                      </div>
                      <span className="text-xs font-black text-indigo-400">{at.e}</span>
                    </div>
                  ))}
                </div>
              </div>
            </>
          )}

          {/* Dashboard View: Parent role */}
          {profile.role === 'parent' && (
            <>
              {/* Linked Player summary */}
              <div className="bg-slate-900 border border-slate-850 rounded-2xl p-4">
                <span className="text-[9px] font-bold text-slate-400 tracking-widest block uppercase">LINKED DEPENDENT ATHLETE</span>
                <div className="flex items-center gap-3 mt-3">
                  <div className="w-10 h-10 bg-indigo-500/10 rounded-full flex items-center justify-center">
                    <UserCheck className="w-5 h-5 text-[#2F80ED]" />
                  </div>
                  <div>
                    <span className="text-xs font-bold text-white block">Alex Rivera</span>
                    <span className="text-[9px] text-emerald-400 font-bold block mt-0.5">Intermediate Junior Class (Tennis Singlet)</span>
                  </div>
                </div>
              </div>

              {/* Parent actions */}
              <div className="grid grid-cols-2 gap-3">
                <button 
                  onClick={() => { setSimSelectedFeature('chat'); addConsoleLog("[Navigation] Synced communications screen"); }}
                  className="p-4 bg-slate-900 border border-slate-850 rounded-2xl text-left"
                >
                  <Send className="w-4 h-4 text-[#2F80ED] mb-3" />
                  <span className="text-xs font-bold text-white block">Chat with Coach</span>
                  <span className="text-[9px] text-slate-500 mt-0.5 block">Review progress</span>
                </button>

                <button 
                  onClick={() => { setSimSelectedFeature('performance'); addConsoleLog("[Navigation] Synced performance logs"); }}
                  className="p-4 bg-slate-900 border border-slate-850 rounded-2xl text-left"
                >
                  <TrendingUp className="w-4 h-4 text-emerald-400 mb-3" />
                  <span className="text-xs font-bold text-white block">ELO Milestones</span>
                  <span className="text-[9px] text-slate-500 mt-0.5 block">Velocity logs</span>
                </button>
              </div>

              {/* Billing transactions details */}
              <div className="bg-slate-900 border border-slate-850 p-4 rounded-2xl space-y-3">
                <span className="text-[9px] font-bold text-slate-400 uppercase tracking-widest block">BILLING INTEGRITY SUMMARY</span>
                <div className="flex justify-between items-center bg-slate-950 p-3 rounded-xl border border-slate-850">
                  <div className="flex items-center gap-2">
                    <DollarSign className="w-4 h-4 text-emerald-400" />
                    <span className="text-xs font-bold text-slate-300">Court Booking Fees</span>
                  </div>
                  <span className="text-xs font-black text-white">$45.00 / paid</span>
                </div>
              </div>
            </>
          )}

          {/* Dashboard View: Admin role */}
          {profile.role === 'admin' && (
            <>
              {/* Admin configuration logs */}
              <div className="bg-slate-900 border border-slate-850 rounded-2xl p-4">
                <span className="text-[9px] font-bold text-slate-400 tracking-widest block uppercase">SYSTEM METRICS CONSOLE</span>
                <div className="grid grid-cols-2 gap-3 mt-3">
                  <div className="p-3.5 bg-slate-950 border border-slate-850 rounded-xl">
                    <span className="text-[8px] font-bold text-slate-500 uppercase tracking-wide">ACTIVE COURTS LOGGED</span>
                    <span className="text-base font-extrabold text-white mt-1 block">8 / 8 Active</span>
                  </div>
                  <div className="p-3.5 bg-slate-950 border border-slate-850 rounded-xl">
                    <span className="text-[8px] font-bold text-slate-500 uppercase tracking-wide">PENDING BOOKINGS</span>
                    <span className="text-base font-extrabold text-[#F2994A] mt-1 block">3 Proposals</span>
                  </div>
                </div>
              </div>

              {/* Reserved courts matrix layout */}
              <div className="bg-slate-900 border border-slate-850 rounded-2xl p-4">
                <span className="text-[9px] font-bold text-slate-400 block mb-3 uppercase tracking-widest">COURT ALLOCATIONS</span>
                <div className="space-y-2">
                  {[
                    { c: 'Center Court 01', user: 'Alex Rivera', t: '10:00 AM - 12:00 PM', status: 'ACTIVE' },
                    { c: 'Clay Court 02', user: 'Carlos Alcaraz', t: '02:00 PM - 04:00 PM', status: 'ACTIVE' }
                  ].map((crt) => (
                    <div key={crt.c} className="p-2 border border-slate-800 bg-slate-950 rounded-xl flex justify-between items-center text-xs">
                      <div>
                        <span className="font-bold text-white block">{crt.c}</span>
                        <span className="text-[9px] text-slate-500 mt-0.5 block">{crt.user} • {crt.t}</span>
                      </div>
                      <span className="px-1.5 py-0.5 rounded bg-emerald-500/10 text-emerald-400 text-[8px] font-black">{crt.status}</span>
                    </div>
                  ))}
                </div>
              </div>
            </>
          )}

        </div>

        {/* Customized Bottom Navigation bar styled precisely 100% like Flutter Material layout */}
        <div className="absolute bottom-4 inset-x-4 h-12 bg-slate-900 border border-slate-800/80 rounded-2xl shadow-xl flex items-center justify-around px-4 z-40">
          <button 
            onClick={() => { setSimActiveTab('home'); setSimSelectedFeature(null); }}
            className={`flex flex-col items-center gap-0.5 ${simActiveTab === 'home' ? 'text-blue-400' : 'text-slate-550'}`}
          >
            <Layers className="w-3.5 h-3.5" />
            <span className="text-[8px] font-extrabold uppercase tracking-wide leading-none">Scaffold</span>
          </button>
          
          <button 
            onClick={() => { setSimActiveTab('feature'); setSimSelectedFeature('chat'); }}
            className={`flex flex-col items-center gap-0.5 ${simActiveTab === 'feature' ? 'text-blue-400' : 'text-slate-550'}`}
          >
            <Sparkles className="w-3.5 h-3.5" />
            <span className="text-[8px] font-extrabold uppercase tracking-wide leading-none">Widgets</span>
          </button>

          <button 
            onClick={() => { setSimActiveTab('settings'); setSimSelectedFeature(null); }}
            className={`flex flex-col items-center gap-0.5 ${simActiveTab === 'settings' ? 'text-blue-400' : 'text-slate-550'}`}
          >
            <Settings className="w-3.5 h-3.5" />
            <span className="text-[8px] font-extrabold uppercase tracking-wide leading-none">Pubspec</span>
          </button>
        </div>

      </div>
    );
  };

  return (
    <div className="min-h-screen bg-[#090D16] text-slate-100 font-sans flex flex-col h-screen overflow-hidden">
      <Toaster position="top-right" richColors />

      {/* Elite IDE top workspace header banner */}
      <header className="h-14 shrink-0 bg-[#0E1321] border-b border-slate-800 flex items-center justify-between px-6 z-50">
        <div className="flex items-center gap-3">
          <div className="w-8.5 h-8.5 rounded-lg bg-blue-600 flex items-center justify-center font-black text-white text-sm shadow-md shadow-blue-500/20">
            F
          </div>
          <div>
            <span className="font-extrabold text-sm tracking-tight text-white block leading-tight">Courtify Flutter Engine Portal</span>
            <span className="text-[9px] font-bold tracking-widest text-[#2F80ED] uppercase flex items-center gap-1.5 mt-0.5">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse" />
              Cross-Platform Dart SDK v3.22 Workspace
            </span>
          </div>
        </div>

        {/* Small Screen Layout toggler */}
        <div className="flex md:hidden bg-[#171D30] p-1 rounded-xl">
          <button 
            onClick={() => setActiveWorkspaceView('simulator')}
            className={`px-3 py-1 rounded-lg text-xs font-bold transition-all ${activeWorkspaceView === 'simulator' ? 'bg-blue-600 text-white' : 'text-slate-400'}`}
          >
            Emulator
          </button>
          <button 
            onClick={() => setActiveWorkspaceView('code')}
            className={`px-3 py-1 rounded-lg text-xs font-bold transition-all ${activeWorkspaceView === 'code' ? 'bg-blue-600 text-white' : 'text-slate-400'}`}
          >
            Dart Code
          </button>
        </div>

        <div className="hidden md:flex items-center gap-5">
          <button 
            onClick={() => {
              setSimLoading(true);
              addConsoleLog("[Dart Compiler] Executed Hot Reload on VM core");
              setTimeout(() => {
                setSimLoading(false);
                addConsoleLog("[Dart Engine] Hot Reload success: synchronized UI tree");
                toast.success("Flutter Hot Reload executed successfully!");
              }, 800);
            }}
            className="px-3.5 py-1.5 bg-emerald-600/10 hover:bg-emerald-600/20 text-emerald-400 border border-emerald-500/20 rounded-full text-[10px] font-bold flex items-center gap-1.5 leading-none transition-all cursor-pointer"
          >
            <RefreshCcw className="w-3 h-3 animate-spin duration-3000" />
            HOT RELOAD WIDGETS
          </button>
          <div className="text-xs font-bold text-slate-400 flex items-center gap-2">
            <Cpu className="w-4 h-4 text-slate-500" />
            Emulator Frame: <span className="text-cyan-400">Canvaskit Render (Port 3000)</span>
          </div>
        </div>
      </header>

      {/* Main split dashboard pane workspace */}
      <div className="flex-1 flex overflow-hidden relative">
        
        {/* LEFT COMPONENT: STUNNING INTERACTIVE SMARTPHONE EMULATOR FRAME */}
        <div className={`flex-1 md:flex-[5] flex flex-col items-center justify-center p-4 bg-[#0a0f1d] overflow-y-auto ${activeWorkspaceView === 'simulator' ? 'flex' : 'hidden md:flex'}`}>
          
          {/* Visual Device Frame */}
          <div className="relative w-full max-w-[420px] aspect-[9/19] max-h-[820px] bg-slate-950 rounded-[44px] p-3 shadow-2xl border-[10px] border-slate-900 flex flex-col my-auto overflow-hidden ring-4 ring-slate-800/20">
            
            {/* Camera / Mic simulator Notch overlay */}
            <div className="absolute top-0 inset-x-0 h-6 bg-slate-950 flex justify-center items-center z-50">
              <div className="w-32 h-4.5 bg-black rounded-b-2xl flex items-center justify-center">
                <div className="w-3 h-3 bg-slate-900 rounded-full mr-2" />
                <div className="w-12 h-1 bg-slate-900 rounded-full" />
              </div>
            </div>

            {/* Simulated Debug banner on screen */}
            {showDebugBanner && (
              <div 
                onClick={() => {
                  setShowDebugBanner(false);
                  toast.info("Debug banner suppressed. Hot reload to reactivate.");
                }}
                className="absolute top-8 right-6 bg-[#2F80ED] text-[8px] font-black text-white px-5 py-0.5 rotate-45 transform translate-x-3 translate-y-[-2px] uppercase select-none cursor-pointer z-50 tracking-wider shadow"
                title="Suppressed Debug Ribbon button"
              >
                DEBUG
              </div>
            )}

            {/* Smart simulated screen viewport */}
            <div className="flex-1 rounded-[32px] overflow-hidden bg-white text-slate-900 relative flex flex-col">
              <AnimatePresence mode="wait">
                {renderSimulatedMobileApp()}
              </AnimatePresence>
            </div>

            {/* Device Home Indicator bar */}
            <div className="absolute bottom-1 inset-x-0 h-4 bg-slate-950 flex justify-center items-center pointer-events-none">
              <div className="w-28 h-1 bg-white/60 rounded-full" />
            </div>
          </div>

          {/* Helper information overlay under preview */}
          <div className="mt-4 flex flex-col items-center text-center max-w-sm px-6 opacity-85">
            <span className="text-[10px] font-black uppercase text-blue-500 tracking-widest flex items-center gap-1.5">
              <Phone className="w-3.5 h-3.5" />
              Interactive Flutter Canvas Web-Engine
            </span>
            <p className="text-[11px] text-slate-400 mt-1">
              Test other client privileges roles! Trigger onboarding baseline setup, test real-time ELO updates, configure slow-motion AI videos, or play with booking slots.
            </p>
          </div>
        </div>

        {/* RIGHT COMPONENT: COMPLETE DART SOURCE CODE VIEW PANEL */}
        <div className={`flex-1 md:flex-[4.5] bg-[#0E1321] border-l border-slate-800 flex flex-col overflow-hidden ${activeWorkspaceView === 'code' ? 'flex' : 'hidden md:flex'}`}>
          
          <div className="h-12 shrink-0 bg-[#0A0D16] border-b border-slate-800 flex items-center justify-between px-4">
            <div className="flex items-center gap-2">
              <FileCode className="w-4 h-4 text-[#2F80ED]" />
              <span className="font-extrabold text-xs text-white uppercase tracking-wider">Dart SDK File System</span>
            </div>

            <button 
              onClick={handleCopyCode}
              disabled={loadingCode || !selectedCode}
              className="px-3 py-1.5 bg-slate-800 hover:bg-slate-750 text-[10px] font-bold rounded-lg flex items-center gap-1.5 transition-all cursor-pointer"
            >
              {copied ? <Check className="w-3.5 h-3.5 text-emerald-400" /> : <Copy className="w-3.5 h-3.5 text-slate-450" />}
              {copied ? 'Copied!' : 'Copy Code'}
            </button>
          </div>

          <div className="flex-1 flex overflow-hidden">
            
            {/* Dart Folder structure Sidebar */}
            <div className="w-1/3 shrink-0 bg-[#0B0F1B] border-r border-slate-800 flex flex-col select-none">
              <div className="p-3 border-b border-slate-800 bg-[#090C16]">
                <span className="text-[9px] font-extrabold tracking-widest text-slate-500 uppercase block mb-1.5">LIB DARTS DIRECTORY</span>
                
                {/* Search files input bar */}
                <div className="relative">
                  <input
                    type="text"
                    placeholder="Search structure..."
                    value={codeSearch}
                    onChange={(e) => setCodeSearch(e.target.value)}
                    className="w-full bg-[#161C2C] border border-slate-800 rounded-lg py-1.5 pl-7 pr-3 text-[10.5px] text-white focus:outline-none focus:border-blue-500 transition-all font-medium"
                  />
                  <Search className="w-3 h-3 text-slate-500 absolute left-2.5 top-2.5" />
                </div>
              </div>

              {/* Recursive list of files */}
              <div className="flex-1 overflow-y-auto p-2 space-y-1">
                {/* Pubspec.yaml selector label */}
                <div 
                  onClick={() => setSelectedFile('pubspec.yaml')}
                  className={`flex items-center gap-2 px-3 py-2 rounded-lg cursor-pointer transition-all text-xs font-bold ${selectedFile === 'pubspec.yaml' ? 'bg-blue-600/10 text-blue-400 border border-blue-500/20' : 'text-slate-400 hover:bg-slate-800'}`}
                >
                  <Layers className="w-3.5 h-3.5 shrink-0" />
                  <span>pubspec.yaml</span>
                </div>

                <div className="pt-2">
                  <span className="text-[9px] font-bold text-slate-500 uppercase tracking-widest px-3">SOURCE CODE FILES</span>
                  <div className="mt-1 space-y-1 pl-1 font-mono">
                    {flutterFiles
                      .filter(f => f.toLowerCase().includes(codeSearch.toLowerCase()) && f !== 'pubspec.yaml')
                      .map((f) => {
                        const isSelected = selectedFile === f;
                        return (
                          <div 
                            key={f}
                            onClick={() => setSelectedFile(f)}
                            className={`flex items-center gap-2 px-2.5 py-1.5 rounded-md cursor-pointer transition-all text-[11px] font-bold ${isSelected ? 'bg-blue-600/15 text-blue-400 border border-blue-500/25' : 'text-slate-400 hover:bg-slate-800'}`}
                          >
                            <FileCode className="w-3 h-3 text-[#2F80ED] shrink-0" />
                            <span className="truncate" title={f}>{f.replace('lib/', '')}</span>
                          </div>
                        );
                      })}
                  </div>
                </div>
              </div>
            </div>

            {/* Displaying active Code file Content box */}
            <div className="flex-1 bg-[#090D16] flex flex-col overflow-hidden relative select-text">
              <div className="h-8 bg-[#0B0F1B] border-b border-slate-800 flex items-center px-4 justify-between">
                <div className="flex items-center gap-1.5 px-3 py-1.5 bg-[#090D16] border-t-2 border-blue-500 text-blue-400 rounded-t text-[10px] font-bold mt-[2px]">
                  <FileCode className="w-3.5 h-3.5" />
                  <span>{selectedFile.split('/').pop()}</span>
                </div>
              </div>

              <div className="flex-1 overflow-auto p-4 bg-[#090D16] no-scrollbar">
                {loadingCode ? (
                  <div className="h-full flex flex-col items-center justify-center space-y-3">
                    <div className="w-8 h-8 border-4 border-cyan-500 border-t-transparent rounded-full animate-spin" />
                    <span className="text-[11px] font-bold text-slate-500">Parsing transpiled Dart structure...</span>
                  </div>
                ) : (
                  <pre className="text-xs leading-relaxed select-text font-mono">
                    {renderCodeViewer(selectedCode)}
                  </pre>
                )}
              </div>

              {/* Code downloading footer section */}
              <div className="p-3 bg-[#0E1321] border-t border-slate-850 flex justify-between items-center text-[10px] text-slate-500 px-4">
                <span>Flutter Workspace Repository Core</span>
                <a 
                  href="/flutter_app/lib/main.dart"
                  download="main.dart"
                  className="flex items-center gap-1.5 px-3 py-1 bg-slate-800 hover:bg-slate-755 rounded-md text-white font-bold transition-all"
                >
                  <Download className="w-3 h-3" />
                  Get Core Source
                </a>
              </div>
            </div>

          </div>

          {/* Debugging log Console panel */}
          <div className="h-32 bg-[#080B13] border-t border-slate-800 flex flex-col">
            <div className="h-7 bg-[#0B0F1B] border-b border-slate-800 px-4 flex items-center justify-between text-[8.5px] font-extrabold tracking-widest text-slate-500">
              <span>DEVELOPER ANALYTICS LOGS (FLUTTER WEBBING)</span>
              <span className="text-emerald-400">● LIVE RUNNING</span>
            </div>
            <div className="flex-1 p-3 overflow-y-auto space-y-1 font-mono text-[10px] text-slate-400">
              {consoleLogs.map((log, idx) => (
                <div key={idx} className="flex gap-2">
                  <span className="text-slate-650 font-bold select-none">[{idx + 1}]</span>
                  <span className={log.includes('failed') ? 'text-rose-500' : log.includes('success') || log.includes('Success') ? 'text-emerald-400' : 'text-slate-300'}>{log}</span>
                </div>
              ))}
            </div>
          </div>

        </div>

      </div>
    </div>
  );
};

export default App;
