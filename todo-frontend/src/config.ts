// API Configuration
// Dynamically determine API URL based on current hostname
const getApiBaseUrl = (): string => {
  // If running in production (not localhost)
  if (typeof window !== 'undefined') {
    const hostname = window.location.hostname;
    const protocol = window.location.protocol;
    
    // If accessing via domain
    if (hostname === 'task-vm.nadunwansooriya.online') {
      return `${protocol}//task-vm.nadunwansooriya.online:8080`;
    }
    
    // If accessing via IP
    if (hostname === '104.154.52.39') {
      return 'http://104.154.52.39:8080';
    }
    
    // If accessing via localhost
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