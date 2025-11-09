// API Configuration
// Dynamically determine API URL based on current hostname
const getApiBaseUrl = (): string => {
  // If running in production (not localhost)
  if (typeof window !== 'undefined') {
    const hostname = window.location.hostname;
    const protocol = window.location.protocol;
    const port = window.location.port;
    
    // If accessing via domain or IP (production), use relative URL
    // This allows nginx to proxy /api to backend, avoiding HTTPS mixed content issues
    if (hostname === 'task-vm.nadunwansooriya.online' || hostname === '104.154.52.39') {
      // Use current origin (works for both HTTP and HTTPS)
      return `${protocol}//${hostname}${port ? ':' + port : ''}`;
    }
    
    // If accessing via localhost (development)
    if (hostname === 'localhost' || hostname === '127.0.0.1') {
      return 'http://localhost:8080';
    }
  }
  
  // Fallback to environment variable or default
  return process.env.REACT_APP_API_URL || 'http://localhost:8080';
};

export const API_BASE_URL = getApiBaseUrl();

// API Endpoints
export const API_ENDPOINTS = {
  AUTH: `${API_BASE_URL}/api/auth`,
  TASKS: `${API_BASE_URL}/api/tasks`,
};