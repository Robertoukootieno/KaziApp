/**
 * Base class for all command handlers
 * Provides common functionality for handling commands in CQRS pattern
 */
class CommandHandler {
  constructor() {
    this.handlerName = this.constructor.name;
  }

  /**
   * Handle a command (to be implemented by subclasses)
   */
  async handle(command) {
    throw new Error(`Handle method must be implemented by ${this.handlerName}`);
  }

  /**
   * Get supported command types (to be implemented by subclasses)
   */
  getSupportedCommands() {
    throw new Error(`getSupportedCommands method must be implemented by ${this.handlerName}`);
  }

  /**
   * Check if this handler can handle the given command
   */
  canHandle(command) {
    const supportedCommands = this.getSupportedCommands();
    return supportedCommands.some(CommandType => command instanceof CommandType);
  }

  /**
   * Validate command before handling
   */
  async validateCommand(command) {
    if (!command) {
      throw new Error('Command is required');
    }

    if (!this.canHandle(command)) {
      throw new Error(`${this.handlerName} cannot handle command of type ${command.commandType}`);
    }

    // Check if command is expired
    if (command.isExpired()) {
      throw new Error(`Command ${command.commandId} has expired`);
    }

    // Additional validation can be added here
    return true;
  }

  /**
   * Execute command with validation and error handling
   */
  async execute(command) {
    try {
      // Validate command
      await this.validateCommand(command);

      // Handle the command
      const result = await this.handle(command);

      return {
        success: true,
        handlerName: this.handlerName,
        commandId: command.commandId,
        commandType: command.commandType,
        result,
        timestamp: new Date().toISOString(),
      };

    } catch (error) {
      return {
        success: false,
        handlerName: this.handlerName,
        commandId: command.commandId,
        commandType: command.commandType,
        error: error.message,
        timestamp: new Date().toISOString(),
      };
    }
  }

  /**
   * Get handler metadata
   */
  getMetadata() {
    return {
      handlerName: this.handlerName,
      supportedCommands: this.getSupportedCommands().map(cmd => cmd.name),
    };
  }
}

module.exports = CommandHandler;
