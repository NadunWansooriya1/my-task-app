import React, { useState } from 'react';
import {
  Container,
  Paper,
  Typography,
  Box,
  TextField,
  Button,
  Alert,
  CircularProgress,
  Grid,
  Link,
} from '@mui/material';
import axios from 'axios';
import { toast } from 'react-toastify';
import { API_ENDPOINTS } from './config';

const GlassCard = ({ children }: { children: React.ReactNode }) => (
  <Paper
    elevation={0}
    sx={{
      background: 'rgba(255, 255, 255, 0.15)',
      backdropFilter: 'blur(12px)',
      borderRadius: 3,
      border: '1px solid rgba(255, 255, 255, 0.2)',
      p: { xs: 3, sm: 4 },
      boxShadow: '0 8px 32px rgba(0, 0, 0, 0.1)',
      transition: 'all 0.3s ease',
      '&:hover': {
        boxShadow: '0 12px 40px rgba(0, 0, 0, 0.15)',
        transform: 'translateY(-4px)',
      },
    }}
  >
    {children}
  </Paper>
);

const AuthPage: React.FC = () => {
  // Login State
  const [loginUsername, setLoginUsername] = useState('');
  const [loginPassword, setLoginPassword] = useState('');
  const [loginError, setLoginError] = useState<string | null>(null);
  const [loginLoading, setLoginLoading] = useState(false);

  // Register State
  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [registerPassword, setRegisterPassword] = useState('');
  const [registerError, setRegisterError] = useState<string | null>(null);
  const [registerLoading, setRegisterLoading] = useState(false);

  // Handle Login
  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoginLoading(true);
    setLoginError(null);
    try {
      const { data } = await axios.post(`${API_ENDPOINTS.AUTH}/login`, {
        username: loginUsername,
        password: loginPassword,
      });
      toast.success('Welcome back!');
      // Handle token (e.g., save to localStorage or context)
      localStorage.setItem('token', data.token);
      // Redirect or update app state
      window.location.href = '/dashboard';
    } catch (err: any) {
      setLoginError(err.response?.data?.message ?? 'Invalid credentials');
    } finally {
      setLoginLoading(false);
    }
  };

  // Handle Register
  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    setRegisterLoading(true);
    setRegisterError(null);
    try {
      await axios.post(`${API_ENDPOINTS.AUTH}/register`, {
        fullName,
        email,
        password: registerPassword,
      });
      toast.success('Account created! Please sign in.');
      // Optionally auto-login or switch to login form
    } catch (err: any) {
      setRegisterError(err.response?.data?.message ?? 'Registration failed');
    } finally {
      setRegisterLoading(false);
    }
  };

  return (
    <Box
      sx={{
        minHeight: '100vh',
        background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        p: { xs: 2, sm: 3 },
        position: 'relative',
        overflow: 'hidden',
      }}
    >
      {/* Optional decorative orbs */}
      <Box
        sx={{
          position: 'absolute',
          width: 400,
          height: 400,
          borderRadius: '50%',
          background: 'rgba(255, 255, 255, 0.1)',
          top: -100,
          left: -100,
          filter: 'blur(80px)',
        }}
      />
      <Box
        sx={{
          position: 'absolute',
          width: 300,
          height: 300,
          borderRadius: '50%',
          background: 'rgba(150, 100, 255, 0.2)',
          bottom: -80,
          right: -80,
          filter: 'blur(70px)',
        }}
      />

      <Container maxWidth="lg">
        <Grid container spacing={{ xs: 4, md: 6 }} justifyContent="center">
          {/* Create Account Card */}
          <Grid item xs={12} md={6}>
            <GlassCard>
              <Typography
                component="h1"
                variant="h5"
                fontWeight={700}
                textAlign="center"
                mb={1}
                color="white"
              >
                Create Account
              </Typography>
              <Typography
                variant="body2"
                color="rgba(255, 255, 255, 0.8)"
                textAlign="center"
                mb={3}
              >
                Join us to start managing tasks
              </Typography>

              <Box component="form" onSubmit={handleRegister}>
                <TextField
                  margin="normal"
                  required
                  fullWidth
                  label="Full Name"
                  autoFocus
                  value={fullName}
                  onChange={(e) => setFullName(e.target.value)}
                  InputProps={{
                    style: { color: 'white' },
                  }}
                  InputLabelProps={{
                    style: { color: 'rgba(255, 255, 255, 0.7)' },
                  }}
                  sx={{
                    '& .MuiOutlinedInput-root': {
                      '& fieldset': { borderColor: 'rgba(255, 255, 255, 0.3)' },
                      '&:hover fieldset': { borderColor: 'rgba(255, 255, 255, 0.5)' },
                      '&.Mui-focused fieldset': { borderColor: '#fff' },
                    },
                  }}
                />
                <TextField
                  margin="normal"
                  required
                  fullWidth
                  label="Email"
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  InputProps={{
                    style: { color: 'white' },
                  }}
                  InputLabelProps={{
                    style: { color: 'rgba(255, 255, 255, 0.7)' },
                  }}
                  sx={{
                    '& .MuiOutlinedInput-root': {
                      '& fieldset': { borderColor: 'rgba(255, 255, 255, 0.3)' },
                      '&:hover fieldset': { borderColor: 'rgba(255, 255, 255, 0.5)' },
                      '&.Mui-focused fieldset': { borderColor: '#fff' },
                    },
                  }}
                />
                <TextField
                  margin="normal"
                  required
                  fullWidth
                  label="Password"
                  type="password"
                  helperText="min 6 characters"
                  value={registerPassword}
                  onChange={(e) => setRegisterPassword(e.target.value)}
                  InputProps={{
                    style: { color: 'white' },
                  }}
                  InputLabelProps={{
                    style: { color: 'rgba(255, 255, 255, 0.7)' },
                  }}
                  FormHelperTextProps={{
                    style: { color: 'rgba(255, 255, 255, 0.6)' },
                  }}
                  sx={{
                    '& .MuiOutlinedInput-root': {
                      '& fieldset': { borderColor: 'rgba(255, 255, 255, 0.3)' },
                      '&:hover fieldset': { borderColor: 'rgba(255, 255, 255, 0.5)' },
                      '&.Mui-focused fieldset': { borderColor: '#fff' },
                    },
                  }}
                />

                {registerError && (
                  <Alert severity="error" sx={{ mt: 2, background: 'rgba(255,0,0,0.1)', color: 'white' }}>
                    {registerError}
                  </Alert>
                )}

                <Button
                  type="submit"
                  fullWidth
                  variant="contained"
                  size="large"
                  disabled={registerLoading}
                  sx={{
                    mt: 3,
                    mb: 2,
                    py: 1.4,
                    background: 'linear-gradient(45deg, #6e48aa 30%, #9d50bb 90%)',
                    boxShadow: '0 3px 10px rgba(0,0,0,0.2)',
                    '&:hover': {
                      background: 'linear-gradient(45deg, #5a3a8d 30%, #8e44ad 90%)',
                    },
                  }}
                >
                  {registerLoading ? <CircularProgress size={24} color="inherit" /> : 'Create Account'}
                </Button>

                <Typography variant="body2" color="rgba(255, 255, 255, 0.7)" textAlign="center">
                  Already have an account?{' '}
                  <Link href="#" color="white" fontWeight={600} underline="none">
                    Sign in
                  </Link>
                </Typography>
              </Box>
            </GlassCard>
          </Grid>

          {/* Sign In Card */}
          <Grid item xs={12} md={6}>
            <GlassCard>
              <Typography
                component="h1"
                variant="h5"
                fontWeight={700}
                textAlign="center"
                mb={1}
                color="white"
              >
                Task Manager
              </Typography>
              <Typography
                variant="body2"
                color="rgba(255, 255, 255, 0.8)"
                textAlign="center"
                mb={3}
              >
                Sign in to manage your tasks
              </Typography>

              <Box component="form" onSubmit={handleLogin}>
                <TextField
                  margin="normal"
                  required
                  fullWidth
                  label="Username"
                  autoComplete="username"
                  autoFocus
                  value={loginUsername}
                  onChange={(e) => setLoginUsername(e.target.value)}
                  InputProps={{
                    style: { color: 'white' },
                  }}
                  InputLabelProps={{
                    style: { color: 'rgba(255, 255, 255, 0.7)' },
                  }}
                  sx={{
                    '& .MuiOutlinedInput-root': {
                      '& fieldset': { borderColor: 'rgba(255, 255, 255, 0.3)' },
                      '&:hover fieldset': { borderColor: 'rgba(255, 255, 255, 0.5)' },
                      '&.Mui-focused fieldset': { borderColor: '#fff' },
                    },
                  }}
                />
                <TextField
                  margin="normal"
                  required
                  fullWidth
                  label="Password"
                  type="password"
                  autoComplete="current-password"
                  value={loginPassword}
                  onChange={(e) => setLoginPassword(e.target.value)}
                  InputProps={{
                    style: { color: 'white' },
                  }}
                  InputLabelProps={{
                    style: { color: 'rgba(255, 255, 255, 0.7)' },
                  }}
                  sx={{
                    '& .MuiOutlinedInput-root': {
                      '& fieldset': { borderColor: 'rgba(255, 255, 255, 0.3)' },
                      '&:hover fieldset': { borderColor: 'rgba(255, 255, 255, 0.5)' },
                      '&.Mui-focused fieldset': { borderColor: '#fff' },
                    },
                  }}
                />

                {loginError && (
                  <Alert severity="error" sx={{ mt: 2, background: 'rgba(255,0,0,0.1)', color: 'white' }}>
                    {loginError}
                  </Alert>
                )}

                <Button
                  type="submit"
                  fullWidth
                  variant="contained"
                  size="large"
                  disabled={loginLoading}
                  sx={{
                    mt: 3,
                    mb: 2,
                    py: 1.4,
                    background: 'linear-gradient(45deg, #6e48aa 30%, #9d50bb 90%)',
                    boxShadow: '0 3px 10px rgba(0,0,0,0.2)',
                    '&:hover': {
                      background: 'linear-gradient(45deg, #5a3a8d 30%, #8e44ad 90%)',
                    },
                  }}
                >
                  {loginLoading ? <CircularProgress size={24} color="inherit" /> : 'Sign In'}
                </Button>

                <Typography variant="body2" color="rgba(255, 255, 255, 0.7)" textAlign="center">
                  Don't have an account?{' '}
                  <Link href="#" color="white" fontWeight={600} underline="none">
                    Create account
                  </Link>
                </Typography>
              </Box>
            </GlassCard>
          </Grid>
        </Grid>
      </Container>
    </Box>
  );
};

export default AuthPage;