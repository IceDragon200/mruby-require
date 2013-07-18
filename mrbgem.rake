module MRuby
  module Gem
    class List
      include Enumerable
      def reject!(&x)
        @ary.reject! &x
      end
      def uniq(&x)
        @ary.uniq &x
      end
    end
  end
  class Build
    alias_method :old_print_build_summary_for_require, :print_build_summary
    def print_build_summary 
      old_print_build_summary_for_require

      Rake::Task.tasks.each do |t|
        if t.name =~ /\.so$/
          t.invoke
        end
      end

      unless @bundled.empty?
        puts "================================================"
          puts "     Bundled Gems:"
          @bundled.map(&:name).each do |name|
          puts "             #{name}"
        end
        puts "================================================"
      end
    end
  end
end

MRuby::Gem::Specification.new('mruby-require') do |spec|
  spec.license = 'MIT'
  spec.authors = 'mattn'
  spec.cc.include_paths << ["#{build.root}/src"]

  if RUBY_PLATFORM.downcase != /mswin(?!ce)|mingw|bccwin/
    spec.linker.libraries << ['dl']
    spec.cc.flags << "-DMRBGEMS_ROOT=\\\"#{File.expand_path build_dir}/lib\\\""
  else
    spec.cc.flags << "-DMRBGEMS_ROOT=\"\"\"#{File.expand_path build_dir}/lib\"\"\""
  end
end
