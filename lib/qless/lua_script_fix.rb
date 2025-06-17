require_relative './lua_script'

# Monkey patch to fix the Lua script argument handling issue
module Qless
  class LuaScript
    # Redefine the private _call method to ensure all arguments are properly converted to strings
    private
    
    if USING_LEGACY_REDIS_VERSION
      def _call(*argv)
        # Convert all arguments to strings to fix the "Lua redis() command arguments must be strings or integers" error
        string_args = argv.map { |arg| arg.to_s }
        @redis.evalsha(@sha, 0, *string_args)
      end
    else
      def _call(*argv)
        # Convert all arguments to strings to fix the "Lua redis() command arguments must be strings or integers" error
        string_args = argv.map { |arg| arg.to_s }
        @redis.evalsha(@sha, keys: [], argv: string_args)
      end
    end
  end
end
