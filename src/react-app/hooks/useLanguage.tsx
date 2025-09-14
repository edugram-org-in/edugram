  import { createContext, useContext, useEffect, useState } from 'react';
  import { Language, translations, TranslationKey } from '@/shared/types';
  
  interface LanguageContextType {
    language: Language;
    setLanguage: (lang: Language) => void;
    t: (key: TranslationKey) => string;
  }
  
  const LanguageContext = createContext<LanguageContextType | null>(null);
  
  export function LanguageProvider({ children }: { children: React.ReactNode }) {
    const [language, setLanguageState] = useState<Language>('english');
  
    const setLanguage = (lang: Language) => {
      setLanguageState(lang);
      localStorage.setItem('edugram-language', lang);
    };
  
    const t = (key: TranslationKey): string => {
      return translations[language]?.[key] || translations.english[key] || key;
    };
  
    useEffect(() => {
      const savedLanguage = localStorage.getItem('edugram-language') as Language;
      if (savedLanguage && Object.keys(translations).includes(savedLanguage)) {
        setLanguageState(savedLanguage);
      }
    }, []);
  
    return (
      <LanguageContext.Provider value={{ language, setLanguage, t }}>
        {children}
      </LanguageContext.Provider>
    );
  }
  
  export function useLanguage() {
    const context = useContext(LanguageContext);
    if (!context) {
      throw new Error('useLanguage must be used within a LanguageProvider');
    }
    return context;
  }
