module.exports = main:
  files: [
    {
      expand: true
      cwd: "public"
      src: [
        "assets/css/**"
        "assets/img/**"
        "favicons/**"
        "files/**"
        "packages/**"
        "vendor/**"
        "!vendor/bower"
        "*.txt"
        "*.php"
      ]
      dest: "dist/public/"
    }
    {
      expand: true
      src: [
        "app/**"
        "vendor/**"
        "bootstrap/**"
        "*.php"
      ]
      dest: "dist"
    }
  ]