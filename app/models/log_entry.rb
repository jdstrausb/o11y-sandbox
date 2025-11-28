class LogEntry < ApplicationRecord
  enum :severity, { 
    debug: 'DEBUG', 
    info: 'INFO', 
    warn: 'WARN', 
    error: 'ERROR', 
    fatal: 'FATAL' 
  }
end
