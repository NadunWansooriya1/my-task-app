-- Database Initialization Script for Spring Boot Todo API
-- Connect to the correct database
\c taskdb;

-- Create indexes for better query performance
-- These 'IF NOT EXISTS' commands are safe to run multiple times
CREATE INDEX IF NOT EXISTS idx_task_date ON task(task_date);
CREATE INDEX IF NOT EXISTS idx_task_user_id ON task(user_id);
CREATE INDEX IF NOT EXISTS idx_task_completed ON task(completed);
CREATE INDEX IF NOT EXISTS idx_task_date_completed ON task(task_date, completed);

-- Insert sample tasks for testing
-- 'ON CONFLICT DO NOTHING' prevents errors if data already exists
INSERT INTO task (title, description, completed, user_id, task_date)
VALUES
    ('Setup GCP Deployment', 'Configure VM, Docker, and deploy the application', false, 'admin', CURRENT_DATE),
    ('Configure Database', 'Set up PostgreSQL with proper credentials', true, 'admin', CURRENT_DATE),
    ('Test API Endpoints', 'Verify all CRUD operations work correctly', false, 'admin', CURRENT_DATE),
    ('Setup CI/CD Pipeline', 'Configure GitHub Actions for automatic deployment', false, 'admin', CURRENT_DATE + INTERVAL '1 day'),
    ('Enable HTTPS', 'Configure SSL certificate with Let''s Encrypt', false, 'admin', CURRENT_DATE + INTERVAL '2 days')
ON CONFLICT DO NOTHING;

-- Grant all privileges to the 'admin' user
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin;

-- Print a success message to the Docker logs
DO $$
BEGIN
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'Database initialization completed!';
    RAISE NOTICE '==========================================';
END $$;