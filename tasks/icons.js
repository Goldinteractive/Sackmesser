var Grunticon = require( 'grunticon-lib' ),
  grunticon = new Grunticon(
    process.env.IN.split(/\s/gi), // source folder
    process.env.OUT,  // output folder
    // grunticons options
    {
      colors: {
        coolBlue: '#0000ff'
      }
    })

grunticon.process(function() {
  console.log('Icons generated!')
})