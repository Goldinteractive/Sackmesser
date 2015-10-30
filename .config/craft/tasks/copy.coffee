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
        'shared-variables.json'
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