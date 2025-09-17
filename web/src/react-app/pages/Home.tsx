import { useEffect } from 'react';
import { useNavigate } from 'react-router';
import { useAuth } from '@getmocha/users-service/react';
import { Loader2 } from 'lucide-react';

export default function Home() {
  const { user, isPending } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    if (!isPending) {
      if (user) {
        // User is authenticated, check if they have app user data
        fetch('/api/users/me')
          .then(res => res.json())
          .then(data => {
            if (data.appUser) {
              // User exists in our database, redirect to appropriate dashboard
              if (data.appUser.user_type === 'child') {
                navigate('/child');
              } else if (data.appUser.user_type === 'teacher') {
                navigate('/teacher');
              } else {
                navigate('/login');
              }
            } else {
              // User authenticated but no app data, go to login to set up
              navigate('/login');
            }
          })
          .catch(() => {
            navigate('/login');
          });
      } else {
        // User not authenticated, start onboarding flow
        navigate('/splash');
      }
    }
  }, [user, isPending, navigate]);

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-50 to-pink-50 dark:from-gray-900 dark:to-gray-800 flex items-center justify-center">
      <div className="text-center">
        <div className="animate-spin mb-4">
          <Loader2 className="w-12 h-12 text-orange-500 mx-auto" />
        </div>
        <p className="text-gray-600 dark:text-gray-300">Loading Edugram...</p>
      </div>
    </div>
  );
}
