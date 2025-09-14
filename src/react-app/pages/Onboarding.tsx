import { useState } from 'react';
import { useNavigate } from 'react-router';
import { motion, AnimatePresence } from 'framer-motion';
import { ChevronRight, ChevronLeft, BookOpen, Gamepad2, Trophy, Globe } from 'lucide-react';
import Button from '@/react-app/components/Button';
import LanguageSelector from '@/react-app/components/LanguageSelector';
import { useLanguage } from '@/react-app/hooks/useLanguage';

const onboardingSlides = [
  {
    icon: BookOpen,
    titleKey: 'learn' as const,
    description: 'Interactive lessons with stories, games, and activities designed for children',
    image: '🎨',
  },
  {
    icon: Gamepad2,
    titleKey: 'games' as const,
    description: 'Fun educational games that make learning enjoyable and engaging',
    image: '🎮',
  },
  {
    icon: Globe,
    titleKey: 'welcome' as const,
    description: 'Learn in your native language with multi-language support',
    image: '🌍',
  },
  {
    icon: Trophy,
    titleKey: 'achievements' as const,
    description: 'Earn stars, coins, and badges as you complete lessons and games',
    image: '🏆',
  },
];

export default function Onboarding() {
  const [currentSlide, setCurrentSlide] = useState(0);
  const navigate = useNavigate();
  const { t } = useLanguage();

  const nextSlide = () => {
    if (currentSlide < onboardingSlides.length - 1) {
      setCurrentSlide(currentSlide + 1);
    } else {
      navigate('/login');
    }
  };

  const prevSlide = () => {
    if (currentSlide > 0) {
      setCurrentSlide(currentSlide - 1);
    }
  };

  const skipOnboarding = () => {
    navigate('/login');
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-orange-50 dark:from-gray-900 dark:to-gray-800 flex flex-col">
      {/* Header */}
      <div className="flex justify-between items-center p-6">
        <div className="flex items-center gap-3">
          <div className="text-2xl">🎓</div>
          <h1 className="text-2xl font-bold text-gray-800 dark:text-white">Edugram</h1>
        </div>
        
        <div className="flex items-center gap-4">
          <LanguageSelector />
          <Button variant="ghost" onClick={skipOnboarding}>
            {t('login')}
          </Button>
        </div>
      </div>

      {/* Slide content */}
      <div className="flex-1 flex items-center justify-center px-6">
        <div className="max-w-2xl w-full">
          <AnimatePresence mode="wait">
            <motion.div
              key={currentSlide}
              initial={{ opacity: 0, x: 50 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -50 }}
              transition={{ type: 'spring', stiffness: 300, damping: 30 }}
              className="text-center"
            >
              {/* Large emoji/icon */}
              <motion.div
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                transition={{ delay: 0.2, type: 'spring', stiffness: 200 }}
                className="text-8xl mb-8"
              >
                {onboardingSlides[currentSlide].image}
              </motion.div>

              {/* Title */}
              <motion.h2
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.3 }}
                className="text-4xl font-bold text-gray-800 dark:text-white mb-6"
              >
                {t(onboardingSlides[currentSlide].titleKey)}
              </motion.h2>

              {/* Description */}
              <motion.p
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.4 }}
                className="text-xl text-gray-600 dark:text-gray-300 leading-relaxed mb-12"
              >
                {onboardingSlides[currentSlide].description}
              </motion.p>

              {/* Interactive elements for tapping */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.5 }}
                className="flex justify-center gap-4 mb-8"
              >
                {Array.from({ length: 3 }, (_, i) => {
                  const IconComponent = onboardingSlides[currentSlide].icon;
                  return (
                    <motion.div
                      key={i}
                      whileHover={{ scale: 1.2, rotate: 10 }}
                      whileTap={{ scale: 0.9 }}
                      className="p-4 bg-orange-100 dark:bg-orange-900/30 rounded-full cursor-pointer"
                    >
                      <IconComponent className="w-8 h-8 text-orange-500" />
                    </motion.div>
                  );
                })}
              </motion.div>
            </motion.div>
          </AnimatePresence>
        </div>
      </div>

      {/* Navigation */}
      <div className="p-6">
        {/* Progress indicators */}
        <div className="flex justify-center gap-2 mb-8">
          {onboardingSlides.map((_, index) => (
            <motion.div
              key={index}
              className={`h-2 rounded-full transition-all duration-300 ${
                index === currentSlide 
                  ? 'bg-orange-500 w-8' 
                  : 'bg-gray-300 dark:bg-gray-600 w-2'
              }`}
              layoutId={`progress-${index}`}
            />
          ))}
        </div>

        {/* Navigation buttons */}
        <div className="flex justify-between items-center max-w-md mx-auto">
          <Button
            variant="ghost"
            onClick={prevSlide}
            disabled={currentSlide === 0}
            className="flex items-center gap-2"
          >
            <ChevronLeft className="w-4 h-4" />
            Back
          </Button>

          <Button
            onClick={nextSlide}
            className="flex items-center gap-2"
          >
            {currentSlide === onboardingSlides.length - 1 ? 'Get Started' : 'Next'}
            <ChevronRight className="w-4 h-4" />
          </Button>
        </div>
      </div>
    </div>
  );
}
