import { features } from '@goldinteractive/js-base'

const quotes = [
  ['Programs must be written for people to read, and only incidentally for machines to execute.', 'Harold Abelson'],
  ["You've baked a really lovely cake, but then you've used dog shit for frosting.", 'Steve Jobs'],
  ['Walking on water and developing software from a specification are easy if both are frozen.', 'Edward Berard'],
  ["Programming isn't about what you know; it's about what you can figure out.", 'Chris Pine'],
  ['Think twice, code once', 'Waseem Latif'],
  ['Any fool can write code that a computer can understand. Good programmers write code that humans can understand.', 'Martin Fowler'],
  ['Truth can only be found in one place: the code.', 'Robert C. Martin']
]


/**
 * Example feature child class to show how to use features.
 * Generates random quotes.
 *
 * @extends {module:base/features~Feature}
 */
class RandomQuote extends features.Feature {

  init() {
    var quote = quotes[Math.floor(Math.random()*quotes.length)]
    this.node.innerHTML = quote[0] +' ― '+ quote[1]
  }

  destroy() {
    super.destroy()
    this.node.innerHTML = ''
  }

}

export default RandomQuote
