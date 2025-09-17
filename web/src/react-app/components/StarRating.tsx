import { Star } from 'lucide-react';
import { motion } from 'framer-motion';

interface StarRatingProps {
  rating: number;
  maxRating?: number;
  size?: 'sm' | 'md' | 'lg';
  animate?: boolean;
}

export default function StarRating({ 
  rating, 
  maxRating = 5, 
  size = 'md',
  animate = true 
}: StarRatingProps) {
  const sizes = {
    sm: 'w-4 h-4',
    md: 'w-6 h-6',
    lg: 'w-8 h-8'
  };

  return (
    <div className="flex items-center gap-1">
      {Array.from({ length: maxRating }, (_, i) => {
        const isFullStar = i < Math.floor(rating);
        const isHalfStar = i < rating && i >= Math.floor(rating);
        
        return (
          <motion.div
            key={i}
            initial={animate ? { scale: 0, rotate: -180 } : false}
            animate={animate ? { scale: 1, rotate: 0 } : false}
            transition={{ delay: i * 0.1, type: 'spring', stiffness: 200 }}
          >
            <Star 
              className={`${sizes[size]} ${
                isFullStar 
                  ? 'text-yellow-400 fill-yellow-400' 
                  : isHalfStar
                  ? 'text-yellow-400 fill-yellow-400/50'
                  : 'text-gray-300 dark:text-gray-600'
              }`}
            />
          </motion.div>
        );
      })}
    </div>
  );
}
