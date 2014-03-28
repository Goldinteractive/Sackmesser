module.exports = myIcons:
  files: [
    expand: true
    cwd: "public/assets/img/icons/"
    src: [
      "*.svg"
      "*.png"
    ]
    dest: "public/assets/css/iconsbuild/"
  ]
  options:
    cssprefix: "icon-"