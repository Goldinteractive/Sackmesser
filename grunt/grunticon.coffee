module.exports = myIcons:
  files: [
    expand: true
    cwd: "assets/img/icons/"
    src: [
      "*.svg"
      "*.png"
    ]
    dest: "assets/css/iconsbuild/"
  ]
  options:
    cssprefix: "icon-"