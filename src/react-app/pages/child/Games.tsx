import { motion } from 'framer-motion';
import { Play, Trophy, Clock, Zap, Target } from 'lucide-react';
import Card from '@/react-app/components/Card';
import Button from '@/react-app/components/Button';
import { useLanguage } from '@/react-app/hooks/useLanguage';

const gameCategories = [
  {
    id: 'math',
    title: 'Math Games',
    emoji: '🧮',
    color: 'from-blue-400 to-blue-600',
    games: [
      {
        id: 1,
        title: 'Number Bubbles',
        description: 'Pop bubbles with the right numbers!',
        emoji: '🫧',
        difficulty: 1,
        timeToPlay: '3 min',
        bestScore: 85,
        stars: 3,
        coinsReward: 10
      },
      {
        id: 2,
        title: 'Math Race',
        description: 'Solve problems to win the race!',
        emoji: '🏎️',
        difficulty: 2,
        timeToPlay: '5 min',
        bestScore: 0,
        stars: 0,
        coinsReward: 15
      }
    ]
  },
  {
    id: 'language',
    title: 'Language Games',
    emoji: '📝',
    color: 'from-green-400 to-green-600',
    games: [
      {
        id: 3,
        title: 'Word Builder',
        description: 'Build words from letters!',
        emoji: '🔤',
        difficulty: 1,
        timeToPlay: '4 min',
        bestScore: 92,
        stars: 3,
        coinsReward: 12
      },
      {
        id: 4,
        title: 'Story Match',
        description: 'Match pictures with words!',
        emoji: '🖼️',
        difficulty: 1,
        timeToPlay: '3 min',
        bestScore: 78,
        stars: 2,
        coinsReward: 8
      }
    ]
  },
  {
    id: 'memory',
    title: 'Memory Games',
    emoji: '🧠',
    color: 'from-purple-400 to-purple-600',
    games: [
      {
        id: 5,
        title: 'Animal Memory',
        description: 'Remember animal pairs!',
        emoji: '🐘',
        difficulty: 2,
        timeToPlay: '6 min',
        bestScore: 0,
        stars: 0,
        coinsReward: 18
      },
      {
        id: 6,
        title: 'Color Sequence',
        description: 'Follow the color pattern!',
        emoji: '🌈',
        difficulty: 3,
        timeToPlay: '4 min',
        bestScore: 0,
        stars: 0,
        coinsReward: 20
      }
    ]
  }
];

export default function ChildGames() {
  const { t } = useLanguage();

  const handlePlayGame = (game: any) => {
    // In a real app, this would start the game
    console.log('Starting game:', game.title);
  };

  const getDifficultyColor = (difficulty: number) => {
    switch (difficulty) {
      case 1: return 'text-green-500';
      case 2: return 'text-yellow-500';
      case 3: return 'text-red-500';
      default: return 'text-gray-500';
    }
  };

  const getDifficultyLabel = (difficulty: number) => {
    switch (difficulty) {
      case 1: return 'Easy';
      case 2: return 'Medium';
      case 3: return 'Hard';
      default: return 'Unknown';
    }
  };

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        className="text-center"
      >
        <motion.div
          animate={{ 
            rotate: [0, 10, -10, 0],
            scale: [1, 1.1, 1]
          }}
          transition={{ 
            duration: 2, 
            repeat: Infinity, 
            repeatDelay: 1 
          }}
          className="text-6xl mb-4"
        >
          🎮
        </motion.div>
        <h1 className="text-3xl font-bold text-gray-800 dark:text-white mb-2">
          {t('games')}
        </h1>
        <p className="text-gray-600 dark:text-gray-400">
          Learn while having fun with educational games!
        </p>
      </motion.div>

      {/* Daily Challenge */}
      <motion.div
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ delay: 0.1 }}
      >
        <Card 
          className="p-6 bg-gradient-to-r from-orange-400/20 to-pink-400/20 border-2 border-orange-200 dark:border-orange-700"
          gradient
        >
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              <motion.div
                animate={{ 
                  rotate: [0, 360],
                  scale: [1, 1.1, 1]
                }}
                transition={{ 
                  duration: 3, 
                  repeat: Infinity,
                  ease: "easeInOut"
                }}
                className="text-4xl"
              >
                🏆
              </motion.div>
              <div>
                <h3 className="text-xl font-bold text-gray-800 dark:text-white mb-1">
                  Daily Challenge
                </h3>
                <p className="text-gray-600 dark:text-gray-400">
                  Shape Sorting Quiz - Win extra coins!
                </p>
                <div className="flex items-center gap-2 mt-2">
                  <Zap className="w-4 h-4 text-yellow-500" />
                  <span className="text-sm font-medium text-yellow-600 dark:text-yellow-400">
                    2x Coins Today
                  </span>
                </div>
              </div>
            </div>
            <Button
              onClick={() => console.log('Starting daily challenge')}
              className="flex items-center gap-2"
            >
              <Play className="w-4 h-4" />
              Play Now
            </Button>
          </div>
        </Card>
      </motion.div>

      {/* Game Categories */}
      <div className="space-y-6">
        {gameCategories.map((category, categoryIndex) => (
          <motion.div
            key={category.id}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2 + categoryIndex * 0.1 }}
          >
            <Card className="p-6">
              {/* Category Header */}
              <div className="flex items-center gap-4 mb-6">
                <motion.div
                  whileHover={{ rotate: [0, -15, 15, 0] }}
                  transition={{ duration: 0.6 }}
                  className="text-4xl"
                >
                  {category.emoji}
                </motion.div>
                <div>
                  <h2 className="text-xl font-bold text-gray-800 dark:text-white">
                    {category.title}
                  </h2>
                  <p className="text-sm text-gray-600 dark:text-gray-400">
                    {category.games.length} games available
                  </p>
                </div>
              </div>

              {/* Games Grid */}
              <div className="grid md:grid-cols-2 gap-4">
                {category.games.map((game, gameIndex) => (
                  <motion.div
                    key={game.id}
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ 
                      delay: 0.3 + categoryIndex * 0.1 + gameIndex * 0.05 
                    }}
                    whileHover={{ y: -2 }}
                  >
                    <Card 
                      className="p-5 cursor-pointer hover:shadow-lg transition-all"
                      onClick={() => handlePlayGame(game)}
                    >
                      <div className="flex items-start justify-between mb-4">
                        <div className="flex items-center gap-3">
                          <motion.div
                            whileHover={{ scale: 1.2, rotate: 10 }}
                            className="text-3xl"
                          >
                            {game.emoji}
                          </motion.div>
                          <div>
                            <h4 className="font-bold text-gray-800 dark:text-white">
                              {game.title}
                            </h4>
                            <p className="text-sm text-gray-600 dark:text-gray-400">
                              {game.description}
                            </p>
                          </div>
                        </div>

                        {/* Play Button */}
                        <motion.div
                          whileHover={{ scale: 1.1 }}
                          whileTap={{ scale: 0.9 }}
                          className="w-12 h-12 bg-orange-500 hover:bg-orange-600 text-white rounded-full flex items-center justify-center cursor-pointer"
                        >
                          <Play className="w-5 h-5 ml-1" />
                        </motion.div>
                      </div>

                      {/* Game Stats */}
                      <div className="space-y-3">
                        {/* Difficulty and Time */}
                        <div className="flex items-center justify-between text-sm">
                          <div className="flex items-center gap-1">
                            <Target className={`w-4 h-4 ${getDifficultyColor(game.difficulty)}`} />
                            <span className={`font-medium ${getDifficultyColor(game.difficulty)}`}>
                              {getDifficultyLabel(game.difficulty)}
                            </span>
                          </div>
                          <div className="flex items-center gap-1 text-gray-600 dark:text-gray-400">
                            <Clock className="w-4 h-4" />
                            {game.timeToPlay}
                          </div>
                        </div>

                        {/* Best Score and Rewards */}
                        <div className="flex items-center justify-between">
                          <div className="flex items-center gap-2">
                            {game.bestScore > 0 ? (
                              <>
                                <Trophy className="w-4 h-4 text-yellow-500" />
                                <span className="text-sm font-medium text-gray-700 dark:text-gray-300">
                                  Best: {game.bestScore}
                                </span>
                              </>
                            ) : (
                              <span className="text-sm text-gray-500 dark:text-gray-400">
                                Not played yet
                              </span>
                            )}
                          </div>
                          
                          <div className="flex items-center gap-1">
                            <span className="text-orange-500 text-lg">🪙</span>
                            <span className="text-sm font-medium text-orange-600 dark:text-orange-400">
                              +{game.coinsReward}
                            </span>
                          </div>
                        </div>

                        {/* Stars */}
                        <div className="flex items-center gap-1">
                          {Array.from({ length: 3 }, (_, i) => (
                            <motion.div
                              key={i}
                              initial={{ scale: 0 }}
                              animate={{ scale: 1 }}
                              transition={{ 
                                delay: 0.5 + categoryIndex * 0.1 + gameIndex * 0.05 + i * 0.1 
                              }}
                            >
                              <span className={`text-lg ${
                                i < game.stars ? 'text-yellow-400' : 'text-gray-300 dark:text-gray-600'
                              }`}>
                                ⭐
                              </span>
                            </motion.div>
                          ))}
                        </div>
                      </div>
                    </Card>
                  </motion.div>
                ))}
              </div>
            </Card>
          </motion.div>
        ))}
      </div>
    </div>
  );
}
