project('zbuild', 'cpp',
  default_options : ['cpp_std=c++23']
)

link_static = get_option('static')

# Optional: Add a linker flag for full static if desired
link_args = link_static ? ['-static'] : []

# Dependencies
libcurl_dep = dependency('libcurl', static: link_static, required: true)
libcrypto_dep = dependency('libcrypto', static: link_static, required: true)
boost_dep = dependency('boost', version: '<1.88')


executable('zbuild',
  ['main.cpp', 'manager.cpp', 'helper.cpp', 'zbuild.cpp', 'archiver.cpp', 'executor.cpp'],
  link_args: link_args,
  dependencies: [boost_dep, libcurl_dep, libcrypto_dep]
)
