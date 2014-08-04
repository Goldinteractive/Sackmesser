module.exports = main:
  files: [
    {
      expand: true
      cwd: "assets"
      src: [
        "css/**"
        "img/**"
        "vendor/**"
        "!vendor/bower"
      ]
      dest: "dist/public"
    }
    {
      expand: true
      src: ["*.!(json|rb|md|js)"]
      dest: "dist"
      filter: "isFile"
    }
  ]