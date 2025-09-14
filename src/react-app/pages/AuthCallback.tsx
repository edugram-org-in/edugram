import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router';
import { useAuth } from '@getmocha/users-service/react';
import { motion } from 'framer-motion';
import { Loader2 } from 'lucide-react';

export default function AuthCallback() {
  const [error, setError] = useState<string | null>(null);
  const { } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    const handleCallback = async () => {
      try {
        // Get stored user type and avatar from login page
        const userType = localStorage.getItem('edugram-user-type');
        const avatar = localStorage.getItem('edugram-avatar');
        const phone = localStorage.getItem('edugram-phone');

        // Send user setup data to backend
        const urlParams = new URLSearchParams(window.location.search);
        const code = urlParams.get('code');
        
        if (code && userType) {
          const response = await fetch('/api/sessions', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({
              code,
              user_type: userType,
              avatar_id: avatar,
              phone_number: phone,
            }),
          });

          if (!response.ok) {
            throw new Error('Failed to setup user account');
          }
        }

        // Clean up localStorage
        localStorage.removeItem('edugram-user-type');
        localStorage.removeItem('edugram-avatar');
        localStorage.removeItem('edugram-phone');

        // Redirect based on user type
        if (userType === 'child') {
          navigate('/child');
        } else if (userType === 'teacher') {
          navigate('/teacher');
        } else {
          navigate('/');
        }
      } catch (err) {
        console.error('Auth callback error:', err);
        setError('Authentication failed. Please try again.');
        
        // Redirect to login after error
        setTimeout(() => {
          navigate('/login');
        }, 3000);
      }
    };

    handleCallback();
  }, [navigate]);

  if (error) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-orange-50 to-pink-50 dark:from-gray-900 dark:to-gray-800 flex items-center justify-center p-6">
        <div className="text-center">
          <motion.div
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            className="text-6xl mb-4"
          >
            ❌
          </motion.div>
          <h2 className="text-2xl font-bold text-red-600 dark:text-red-400 mb-2">
            Authentication Error
          </h2>
          <p className="text-gray-600 dark:text-gray-300 mb-4">
            {error}
          </p>
          <p className="text-sm text-gray-500 dark:text-gray-400">
            Redirecting to login page...
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-50 to-pink-50 dark:from-gray-900 dark:to-gray-800 flex items-center justify-center p-6">
      <div className="text-center">
        <motion.div
          animate={{ rotate: 360 }}
          transition={{ duration: 2, repeat: Infinity, ease: 'linear' }}
          className="inline-block mb-6"
        >
          <Loader2 className="w-16 h-16 text-orange-500" />
        </motion.div>
        
        <h2 className="text-3xl font-bold text-gray-800 dark:text-white mb-4">
          Setting up your account...
        </h2>
        
        <p className="text-gray-600 dark:text-gray-300">
          Please wait while we prepare your Edugram experience
        </p>

        {/* Animated progress dots */}
        <div className="flex justify-center gap-2 mt-8">
          {Array.from({ length: 3 }, (_, i) => (
            <motion.div
              key={i}
              className="w-3 h-3 bg-orange-500 rounded-full"
              animate={{
                scale: [1, 1.2, 1],
                opacity: [0.5, 1, 0.5],
              }}
              transition={{
                duration: 1,
                repeat: Infinity,
                delay: i * 0.2,
              }}
            />
          ))}
        </div>
      </div>
    </div>
  );
}
