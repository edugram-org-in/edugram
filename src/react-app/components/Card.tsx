import { motion } from 'framer-motion';
import { ReactNode } from 'react';

interface CardProps {
  children: ReactNode;
  onClick?: () => void;
  className?: string;
  hover?: boolean;
  gradient?: boolean;
}

export default function Card({ 
  children, 
  onClick, 
  className = '', 
  hover = true,
  gradient = false 
}: CardProps) {
  const baseStyles = `
    rounded-3xl shadow-lg backdrop-blur-sm border border-white/20
    ${gradient 
      ? 'bg-gradient-to-br from-orange-400/10 to-pink-400/10' 
      : 'bg-white/90 dark:bg-gray-800/90'
    }
    ${onClick ? 'cursor-pointer' : ''}
  `;

  const cardContent = (
    <div className={`${baseStyles} ${className}`}>
      {children}
    </div>
  );

  if (onClick && hover) {
    return (
      <motion.div
        whileHover={{ 
          scale: 1.02,
          rotateY: 2,
          rotateX: 2,
        }}
        whileTap={{ scale: 0.98 }}
        className="transform-gpu perspective-1000"
        onClick={onClick}
      >
        {cardContent}
      </motion.div>
    );
  }

  if (onClick) {
    return (
      <motion.div
        whileTap={{ scale: 0.98 }}
        onClick={onClick}
      >
        {cardContent}
      </motion.div>
    );
  }

  return cardContent;
}
