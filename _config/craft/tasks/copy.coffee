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
        'vendor/**'
        '!vendor/bower'
        '*.txt'
        '*.php'
      ]
      dest: 'dist/public/'
    }
    {
      expand: true
      src: [
        'crafter/**'
        'craft/**'
      ]
      dest: 'dist'
    }
  ]