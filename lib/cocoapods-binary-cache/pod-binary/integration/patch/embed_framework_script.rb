# A fix in embeded frameworks script.
#
# The framework file in pod target folder is a symblink. The EmbedFrameworksScript use `readlink`
# to read the read path. As the symlink is a relative symlink, readlink cannot handle it well. So
# we override the `readlink` to a fixed version.
#
module Pod
  module Generator
    class EmbedFrameworksScript
      old_method = instance_method(:script)
      define_method(:script) do
        script = old_method.bind(self).call
        # patch the rsync for copy dSYM symlink
        script = script.gsub "rsync --delete", "rsync --copy-links --delete"
      end
    end
  end
end
