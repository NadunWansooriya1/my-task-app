// Before: https://task-vm.nadunwansooriya.online/api/tasks
// After (in code):
const API_BASE = process.env.REACT_APP_API_URL || '/api';

// Usage:
apiClient.get(`${API_BASE}/tasks`, { params: { date } })