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
        # ignore the content of the cache folder..
        '!app/storage/cache/**'
        # .. but copy the folder empty anyway
        'app/storage/cache'
        'vendor/**'
        'bootstrap/**'
        '*.php'
      ]
      dest: 'dist'
    }
  ]