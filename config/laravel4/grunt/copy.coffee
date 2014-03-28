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