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