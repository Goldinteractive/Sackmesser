module.exports = main:
  files: [
    {
      expand: true
      cwd: 'public'
      src: [
        'assets/css/**'
        'assets/img/**'
        'assets/favicons/**'
        'files/**'
        'packages/**'
        'vendor/**'
        '!vendor/bower'
        'shared-variables.json'
        '*.txt'
        '*.php'
      ]
      dest: 'dist/public/'
    }
    {
      expand: true
      src: [
        'app/**'
        'resources/**'
        'database/**'
        'storage/**'
        'config/**'
        'vendor/**'
        'bootstrap/**'
        # ignore the content of the cache folder..
        '!storage/cache/**'
        '!storage/logs/**'
        # .. but copy the folder empty anyway
        'storage/cache'
        '*.php'
      ]
      dest: 'dist'
    }
  ]