import { useEffect } from "react";
import { useNavigate } from "react-router";
import { motion } from "framer-motion";

export default function SplashScreen() {
  const navigate = useNavigate();

  useEffect(() => {
    const timer = setTimeout(() => {
      navigate("/onboarding");
    }, 3000);
    return () => clearTimeout(timer);
  }, [navigate]);

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-400 via-orange-500 to-yellow-400 flex items-center justify-center relative overflow-hidden">
      {/* Floating books in background */}
      <div className="absolute inset-0">
        {Array.from({ length: 8 }, (_, i) => (
          <motion.div
            key={i}
            className="absolute"
            style={{
              left: `${Math.random() * 100}%`,
              top: `${Math.random() * 100}%`,
            }}
            animate={{
              y: [0, -40, 0],
              opacity: [0.4, 1, 0.4],
              rotate: [0, 15, -15, 0],
            }}
            transition={{
              duration: 4 + Math.random() * 2,
              repeat: Infinity,
              delay: Math.random() * 2,
            }}
          >
            📚
          </motion.div>
        ))}
      </div>

      {/* Main content */}
      <div className="text-center relative z-10">
        {/* Avatar instead of Canvas */}
        <motion.div
          initial={{ scale: 0, rotate: -180 }}
          animate={{ scale: 1, rotate: 0 }}
          transition={{ type: "spring", stiffness: 100, damping: 15, duration: 1 }}
          className="w-64 h-64 mx-auto mb-8 relative"
        >
          <div className="absolute inset-0 rounded-full bg-orange-300/40 blur-3xl animate-pulse"></div>
          <img
            src="/images/avatar.png"   // <-- your avatar here
            alt="Edugram Mascot"
            className="w-full h-full object-contain drop-shadow-xl"
          />
        </motion.div>

        {/* App title */}
        <motion.h1
          initial={{ opacity: 0, y: 40 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3, duration: 0.8 }}
          className="text-6xl font-extrabold text-white mb-3 drop-shadow-lg"
        >
          <span className="bg-clip-text text-transparent bg-gradient-to-r from-yellow-200 via-orange-300 to-orange-500">
            Edugram
          </span>
        </motion.h1>

        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.8 }}
          className="text-lg text-white/90 tracking-wide font-medium"
        >
          Learn • Play • Grow
        </motion.p>

        {/* Loading dots */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 1.2 }}
          className="mt-10 flex justify-center"
        >
          <div className="flex space-x-3">
            {Array.from({ length: 3 }, (_, i) => (
              <motion.div
                key={i}
                className="w-4 h-4 rounded-full bg-white shadow-[0_0_10px_rgba(255,200,100,0.8)]"
                animate={{
                  scale: [1, 1.4, 1],
                  opacity: [0.5, 1, 0.5],
                }}
                transition={{
                  duration: 1,
                  repeat: Infinity,
                  delay: i * 0.25,
                }}
              />
            ))}
          </div>
        </motion.div>
      </div>
    </div>
  );
}
