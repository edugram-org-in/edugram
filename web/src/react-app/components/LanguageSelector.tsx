import { ChevronDown, Globe } from 'lucide-react';
import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Language } from '@/shared/types';
import { useLanguage } from '@/react-app/hooks/useLanguage';

const languages = [
  { code: 'english' as Language, name: 'English', native: 'English' },
  { code: 'hindi' as Language, name: 'Hindi', native: 'हिंदी' },
  { code: 'odia' as Language, name: 'Odia', native: 'ଓଡ଼ିଆ' },
  { code: 'telugu' as Language, name: 'Telugu', native: 'తెలుగు' },
  { code: 'bangla' as Language, name: 'Bengali', native: 'বাংলা' },
  { code: 'malayalam' as Language, name: 'Malayalam', native: 'മലയാളം' },
  { code: 'kannada' as Language, name: 'Kannada', native: 'ಕನ್ನಡ' },
];

export default function LanguageSelector() {
  const { language, setLanguage } = useLanguage();
  const [isOpen, setIsOpen] = useState(false);

  const currentLang = languages.find(lang => lang.code === language) || languages[0];

  return (
    <div className="relative">
      <motion.button
        whileHover={{ scale: 1.05 }}
        whileTap={{ scale: 0.95 }}
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 px-3 py-2 bg-white/20 backdrop-blur-sm rounded-xl border border-white/30 text-gray-700 dark:text-gray-300 hover:bg-white/30 transition-all"
      >
        <Globe className="w-4 h-4" />
        <span className="text-sm font-medium">{currentLang.native}</span>
        <ChevronDown className={`w-4 h-4 transition-transform ${isOpen ? 'rotate-180' : ''}`} />
      </motion.button>

      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, y: -10, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: -10, scale: 0.95 }}
            transition={{ type: 'spring', stiffness: 300, damping: 30 }}
            className="absolute right-0 mt-2 w-48 bg-white dark:bg-gray-800 rounded-xl shadow-xl border border-gray-200 dark:border-gray-700 z-50 overflow-hidden"
          >
            {languages.map((lang) => (
              <motion.button
                key={lang.code}
                whileHover={{ backgroundColor: 'rgba(255, 120, 40, 0.1)' }}
                onClick={() => {
                  setLanguage(lang.code);
                  setIsOpen(false);
                }}
                className={`w-full text-left px-4 py-3 text-sm transition-colors ${
                  lang.code === language 
                    ? 'bg-orange-50 dark:bg-orange-900/20 text-orange-600 dark:text-orange-400' 
                    : 'text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700'
                }`}
              >
                <div className="flex items-center justify-between">
                  <span className="font-medium">{lang.native}</span>
                  <span className="text-xs text-gray-500">{lang.name}</span>
                </div>
              </motion.button>
            ))}
          </motion.div>
        )}
      </AnimatePresence>

      {isOpen && (
        <div 
          className="fixed inset-0 z-40" 
          onClick={() => setIsOpen(false)}
        />
      )}
    </div>
  );
}
