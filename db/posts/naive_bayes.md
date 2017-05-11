---
public_id: naive_bayes
title: "Naive Bayes <span class='series'>(Machine Learning for Mere Mortals)</span>"
tags:
  - machine_learning
  - classification
  - naive_bayes
published: true
---

It's no secret that many of the next decade's big innovations will be made possible by artificial intelligence, and as a result, the past few years have shown a boom of interest in machine learning. But for myself and other mere mortals (i.e. people without degrees in both computer science and statistics), the learning materials available online can often feel a bit… daunting.

<figure>
  <div class="image-wrapper">
    <img src="/images/posts/maths.gif" alt="Maths">
  </div>
</figure>

So, in an attempt to make the ML world a little more accessible (and hopefully pick up a few skills along the way), I've decided to document my (mis)adventures in an accessible, example-based manner.

And so begins _Machine Learning for Mere Mortals_.

<figure>
  <div class="image-wrapper">
    <img src="/images/posts/robot-hand.jpg" alt="Maths">
  </div>
</figure>

The first ML strategy we'll talk about is __Naive Bayes__, which is a family of classification algorithms whose common uses include:

- Spam Filtering <span class="tiny-parenthetical">(Does this message from xxx_sexy_kitten92_xxx really need to be read by a human?)</span>
- Sentiment Analysis <span class="tiny-parenthetical">(Does this tweet suggest that Kanye West is happy or sad?)</span>
- Topic Classification <span class="tiny-parenthetical">(Is this newspaper article about sports, politics, or cooking?)</span>
- Facial Recognition <span class="tiny-parenthetical">(Who dat?)</span>

It's also worth noting that Naive Bayes falls into the bucket of __supervised learning__, which <a target="_blank" href="http://nkonst.com/machine-learning-explained-simple-words/">"Machine learning explained in simple words"</a> summarizes nicely:

> Supervised machine learning relies on data where the true label/class was indicated. This is easier to explain using an example: Let us imagine that we want to teach a computer to distinguish pictures of cats and dogs. We can ask some of our friends to send us pictures of cats and dogs adding a tag "cat" or "dog". Labeling is usually done by human annotators to ensure a high quality of data. So now we know the true labels of the pictures and can use this data to "supervise" our algorithm in learning the right way to classify images. Once our algorithm learns how to classify images we can use it on new data and predict labels ("cat" or "dog" in our case) on previously unseen images.

The alternative to supervised learning is _(surprise!)_ <strong><u>un</u>supervised learning</strong>. Where supervised learning prescribes the "correct answer" for each example, unsupervised learning simply presents the data and lets the machine draw its own conclusions. (#youDoYou) In the example of dogs vs cats, an unsupervised algorithm _might_ produce outcomes similar to the supervised learner, grouping animals by species. Or it might choose to group animals by fur color or body size, depending on the specifics of the algorithm and the dataset.

We'll discuss unsupervised learning more in a future post, but for now, let's get back to the supervised world. It sounds like my tea kettle is whistling, so I'm going to let <a target="_blank" href="https://www.analyticsvidhya.com/blog/2015/09/naive-bayes-explained/">Analytics Vidhya</a> provide a definition of Naive Bayes while I make some <span class="no-break">Sleepy Time. :tea:</span>

> It is a classification technique based on Bayes' Theorem with an assumption of independence among predictors. In simple terms, a Naive Bayes classifier assumes that the presence of a particular feature in a class is unrelated to the presence of any other feature. For example, a fruit may be considered to be an apple if it is red, round, and about 3 inches in diameter. Even if these features depend on each other or upon the existence of the other features, all of these properties independently contribute to the probability that this fruit is an apple and that is why it is known as "Naive".

At this point you're probably starting to get a vague sense of how Bayes works his magic, but the specifics are still pretty hazy, right? Well fret not, because we've got an example coming up!

<figure>
  <div class="image-wrapper">
    <img src="/images/posts/hooray.gif" alt="Maths">
  </div>
</figure>


<div class="conversation">
  <div class="message left">
    <div class="message-content">
      So what are we gonna build?!
    </div>
  </div>
  <div class="message right">
    <div class="message-content">
      A tweet classifier!
    </div>
  </div>
  <div class="message left">
    <div class="message-content">
      Say what?
    </div>
  </div>
  <div class="message right">
    <div class="message-content">
      You'll be able to input the text of a tweet (which the classifier has never seen before) and it will try to guess who (amongst the users it knows about) tweeted it. We'll have to train the classifier first, of course.
    </div>
  </div>

  <div class="message left">
    <div class="message-content">
      And how are we going to train this thing?
    </div>
  </div>
  <div class="message right">
    <div class="message-content">
      With these <a target="_blank" href="https://raw.githubusercontent.com/nickcherry/ml_naive_bayes/master/tweets.json">13,755 tweets</a> from <a target="_blank" href="https://twitter.com/DalaiLama">the Dalai Lama</a>, <a target="_blank" href="https://twitter.com/elonmusk">Elon Musk</a>, <a target="_blank" href="https://twitter.com/BarackObama">Barry O.</a>, <a target="_blank" href="https://twitter.com/realDonaldTrump">an orange troll with tiny hands</a>, and <a target="_blank" href="https://twitter.com/big_ben_clock">a strikingly articulate timepiece</a>. The classifier will break each tweet into an array of individual words and keep tallies of how many times each word has been tweeted by each user that it knows about. Basically, it's just a bunch of counting.
    </div>
  </div>
  <div class="message right">
    <div class="message-content">
      By the way, when I say "word", what I really mean is <strong>stem</strong>. You can think of it like the root. For example, we don't really care to differentiate "run" from "running", so we reduce them both to "run" and call it a day. Also, from here on I'm going start referring to each user as a <strong>category</strong>; it's more aligned with statistics lingo. And each tweet is a <strong>document</strong>.
    </div>
  </div>
  <div class="message right">
    <div class="message-content">
      Capiche?
    </div>
  </div>
  <div class="message left">
    <div class="message-content">
      Capiche.
    </div>
  </div>
  <div class="message left">
    <div class="message-content">
      So far nothing sounds too crazy, but how does the guessing work?
    </div>
  </div>
  <div class="message right">
    <div class="message-content">
      Good question! When the classifier receives an input, it first breaks the text into words, just like it does during the training process.
    </div>
  </div>
  <div class="message left">
    <div class="message-content">
      I'm with you…
    </div>
  </div>
  <div class="message right">
    <div class="message-content">
      Then for each stem, it iterates over all the known categories and calculates:
    </div>
  </div>
  <div class="message right">
    <div class="message-content">
      <strong>A</strong>) the probability of the stem appearing in a document in the current category,
    </div>
  </div>
  <div class="message right">
    <div class="message-content">
      <strong>B</strong>) the probability of the stem appearing in a document in any <i>other</i> category,
    </div>
  </div>
  <div class="message right">
    <div class="message-content">
      <strong>C</strong>) the probability that the document belongs to the current category given that it contains the current stem, i.e. <strong>A</strong> / (<strong>A</strong> + <strong>B</strong>). The primary function of this step is to boost the score of categories containing rare terms (present in the document we want to classify) and negate the influence of ubiquitous terms.
    </div>
  </div>
  <div class="message right">
    <div class="message-content">
      Finally, the classifier adds up the probabilities of the document belonging to the current category for each stem (that is to say, it adds up all the <strong>C</strong>s), and whichever category has the highest sum of probabilities wins.
    </div>
  </div>
  <div class="message left">
    <div class="message-content">
      Ummmmm…
    </div>
  </div>
  <div class="message right">
    <div class="message-content">
      I know, I know. It'll make more sense soon, I promise.
    </div>
  </div>
  <div class="message right">
    <div class="message-content">
      To the Code Mobile! :bus:
    </div>
  </div>
</div>

<figure>
  <div class="image-wrapper">
    <img src="/images/posts/cat-driving.gif" alt="Code Mobile">
  </div>
</figure>

Our first order of business is to import <a target="_blank" href="https://github.com/NaturalNode/natural">natural</a>, which is a natural language-processing library for Node.js. It can actually do Bayes classification out of the box (probably better than what we're about to implement), but we want to understand _how_ the technique works; so we'll only be utilizing the <a target="_blank" href="https://en.wikipedia.org/wiki/Tokenization_(lexical_analysis)">tokenization</a> and <a target="_blank" href="https://en.wikipedia.org/wiki/Stemming">stemming</a> modules.

After importing the dependency, we'll start defining a `BayesClassifier` class. In its constructor, we'll instantiate a tokenizer instance and initialize a few objects, which will help us keep track of stem and document counts during the training process. Remember, users are __categories__, tweets are __documents__, and individual words are __stems__.

```javascript
const natural = require('natural');

class BayesClassifier {

  constructor(opts = {}) {
    // Create convenient references to our natural language helpers
    this.tokenizer = new natural.WordTokenizer();
    this.stemmer = natural.PorterStemmer;

    // Initialize object to track total number of occurrences for stems
    this.stemCounts = opts.stemCounts || {};

    // Initialize object to track number of occurrences for stems within each category
    this.stemCountsByCategory = opts.stemCountsByCategory || {};

    // Initialize object to track number of documents trained for each category
    this.documentCountsByCategory = opts.documentCountsByCategory || {};

    // Initialize a set of (optional) stopwords
    this.stopWords = new Set(opts.stopWords);
  }
}

module.exports = BayesClassifier;
```

In the next snippet, we'll implement the `train(category, doc)` method and an `extractStems(doc)` helper. In addition to to handling tokenization and stemming, `extractStems` will filter out any <a target="_blank" href="https://en.wikipedia.org/wiki/Stop_words">stop words</a> encountered. In our tweet classifier, we won't be specifying any stop words (because I believe <a target="_blank" href="http://www.ranks.nl/stopwords">common terms</a> like "against", "myself", or "ought" can actually be useful for identifying categories in this context), but if we choose to add them later, we'll be covered. After extracting stems from the given document, all our `train` method has to do is increment a few counts.

```javascript
train(category, doc) {
  this.extractStems(doc).forEach((stem) => {
    // Increment total stem count
    this.stemCounts[stem] = (this.stemCounts[stem] || 0) + 1;

    // Increment the stem count for our category
    this.stemCountsByCategory[category] = this.stemCountsByCategory[category] || {};
    this.stemCountsByCategory[category][stem] = (this.stemCountsByCategory[category][stem] || 0) + 1;
  });

  // Increment the document count for our category
  this.documentCountsByCategory[category] = (this.documentCountsByCategory[category] || 0) + 1;
}

extractStems(doc) {
  // First we'll tokenize the document's text, e.g. "Yes we can" becomes ["Yes", "we", "can"]
  return this.tokenizer.tokenize(doc)
    // Then remove any stop words from the token array
    .filter((token) => !this.stopWords.has(token))
    // And reduce each word to its downcased stem / root, e.g. "Inspiring" becomes "inspir"
    .map(this.stemmer.stem)
}
```

You can check out <a target="_blank" href="https://gist.github.com/nickcherry/9c48423003b99785367623ec613771f2">this gist</a> to see how our state should look after training the classifier with a few tweets.

Already we're in the home stretch! In this last section, we're going to implement a `classify(doc)` method. As I mentioned before, the first step of classification is to tokenize and stem the given document. Then, for each category we'll compute the sum of independent probabilities that the document belongs to the category given that it contains each stem. Once we have "likelihoods" (the sum of probabilities) for each category, we'll sort from highest to lowest and return the result. The category with the highest score is our best guess.


```javascript
classify(doc) {
  const totalDocCount = this.getTotalDocumentCount();

  // Tokenize and stem the document we're about to classify
  const stems = this.extractStems(doc);

  // Compute probability scores for each category
  const likelihoods = this.categories.map((category) => {
    const catDocCount = this.documentCountsByCategory[category]; // number of docs in the current category
    const inverseCatDocCount = totalDocCount - catDocCount; // number of docs in all other categories

    // Sum the probabilities for each stem in the document
    const score = stems.reduce((score, stem) => {
      // If we've never seen this stem before, there's no need to go through the motions
      if (!this.stemCounts[stem]) return score;

      // Calculate the probability that the stem appears in the current category
      const stemCount = this.stemCountsByCategory[category][stem] || 0; // number of times the stem has appeared in the current category
      const stemProbability = stemCount / catDocCount;

      // Calculate the probability that the stem appears in any other category
      const inverseStemCount = this.stemCounts[stem] - stemCount; // number of times the stem has appeared in all other categories
      const inverseStemProbability = inverseStemCount / inverseCatDocCount;

      // Calculate the probability that the document belongs to the current category
      // given that the document contains the current stem
      const probability = stemProbability / (stemProbability + inverseStemProbability);

      // Add the probability to the existing score for the category stem
      return score + probability;
    }, 0);

    return { category: category, score: score };
  });

  // Sort the likelihoods from highest score to lowest score
  return likelihoods.sort((a, b) => b.score - a.score);
}

get categories() {
  return Object.keys(this.documentCountsByCategory);
}

getTotalDocumentCount() {
  return Object.values(this.documentCountsByCategory)
    .reduce((total, catCount) => total + catCount, 0);
}
```

<hr>

And that's all folks. Now comes the fun part. Let's load up <a target="_blank" href="https://raw.githubusercontent.com/nickcherry/ml_naive_bayes/master/tweets.json">our training set</a> and see how well the classifier handles tweets it's never seen before…

<figure>
  <div class="embedded-content-wrapper">
    <blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">The future can be different if we choose to make it so. There is no time for complacency, hope lies in what action we take.</p>&mdash; Dalai Lama (@DalaiLama) <a href="https://twitter.com/DalaiLama/status/860426388041383936">May 5, 2017</a></blockquote>
  </div>
</figure>

<table class="data-table two-column squeeze equal-column-widths" style="margin-top: -20px; margin-bottom: 50px;">
  <thead>
    <tr>
      <th>Category</th>
      <th>Score</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>:white_check_mark: DalaiLama</td>
      <td>15.59</td>
    </tr>
    <tr>
      <td>BarackObama</td>
      <td>14.01</td>
    </tr>
    <tr>
      <td>realDonaldTrump</td>
      <td>13.50</td>
    </tr>
    <tr>
      <td>elonmusk</td>
      <td>11.48</td>
    </tr>
    <tr>
      <td>big_ben_clock</td>
      <td>0.00</td>
    </tr>
  </tbody>
</table>

<figure>
  <div class="embedded-content-wrapper">
    <blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Thinking about a name for our first tunneling machine …</p>&mdash; Elon Musk (@elonmusk) <a href="https://twitter.com/elonmusk/status/860373617841807360">May 5, 2017</a></blockquote>
  </div>
</figure>

<table class="data-table two-column squeeze equal-column-widths" style="margin-top: -20px; margin-bottom: 50px;">
  <thead>
    <tr>
      <th>Category</th>
      <th>Score</th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>:white_check_mark: elonmusk</td>
      <td>5.55</td>
    </tr>
    <tr>
      <td>BarackObama</td>
      <td>4.47</td>
    </tr>
    <tr>
      <td>realDonaldTrump</td>
      <td>4.06</td>
    </tr>
    <tr>
      <td>DalaiLama</td>
      <td>3.64</td>
    </tr>
    <tr>
      <td>big_ben_clock</td>
      <td>0.00</td>
    </tr>
  </tbody>
</table>

<figure>
  <div class="embedded-content-wrapper">
    <blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Well said, Jimmy. That&#39;s exactly why we fought so hard for the ACA, and why we need to protect it for kids like Billy. And congratulations! <a href="https://t.co/77F8rZrD3P">https://t.co/77F8rZrD3P</a></p>&mdash; Barack Obama (@BarackObama) <a href="https://twitter.com/BarackObama/status/859457313232605184">May 2, 2017</a></blockquote>
  </div>
</figure>

<table class="data-table two-column squeeze equal-column-widths" style="margin-top: -20px; margin-bottom: 50px;">
  <thead>
    <tr>
      <th>Category</th>
      <th>Score</th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>:white_check_mark: BarackObama</td>
      <td>14.89</td>
    </tr>
    <tr>
      <td>elonmusk</td>
      <td>14.54</td>
    </tr>
    <tr>
      <td>realDonaldTrump</td>
      <td>13.57</td>
    </tr>
    <tr>
      <td>DalaiLama</td>
      <td>11.56</td>
    </tr>
    <tr>
      <td>big_ben_clock</td>
      <td>0.00</td>
    </tr>
  </tbody>
</table>


<figure>
  <div class="embedded-content-wrapper">
    <blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Why is it that the Fake News rarely reports Ocare is on its last legs and that insurance companies are fleeing for their lives? It&#39;s dead!</p>&mdash; Donald J. Trump (@realDonaldTrump) <a href="https://twitter.com/realDonaldTrump/status/860637673744195584">May 5, 2017</a></blockquote>
  </div>
</figure>

<table class="data-table two-column squeeze equal-column-widths" style="margin-top: -20px; margin-bottom: 50px;">
  <thead>
    <tr>
      <th>Category</th>
      <th>Score</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>:white_check_mark: realDonaldTrump</td>
      <td>17.53</td>
    </tr>
    <tr>
      <td>elonmusk</td>
      <td>13.49</td>
    </tr>
    <tr>
      <td>BarackObama</td>
      <td>13.02</td>
    </tr>
    <tr>
      <td>DalaiLama</td>
      <td>12.03</td>
    </tr>
    <tr>
      <td>big_ben_clock</td>
      <td>0.01</td>
    </tr>
  </tbody>
</table>



<figure>
  <div class="embedded-content-wrapper">
    <blockquote class="twitter-tweet" data-lang="en"><p lang="tl" dir="ltr">BONG BONG BONG</p>&mdash; Big Ben (@big_ben_clock) <a href="https://twitter.com/big_ben_clock/status/861219075107815424">May 7, 2017</a></blockquote>
  </div>
</figure>

<table class="data-table two-column squeeze equal-column-widths" style="margin-top: -20px; margin-bottom: 50px;">
  <thead>
    <tr>
      <th>Category</th>
      <th>Score</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>:white_check_mark: big_ben_clock</td>
      <td>3.00</td>
    </tr>
    <tr>
      <td>BarackObama</td>
      <td>0.00</td>
    </tr>
    <tr>
      <td>DalaiLama</td>
      <td>0.00</td>
    </tr>
    <tr>
      <td>elonmusk</td>
      <td>0.00</td>
    </tr>
    <tr>
      <td>realDonaldTrump</td>
      <td>0.00</td>
    </tr>
  </tbody>
</table>

<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<figure>
  <div class="image-wrapper">
    <img src="/images/posts/purrrrfect.gif" width="200" alt="Purrrrfect">
  </div>
</figure>

Not too shabby! As the name suggests, Naive Bayes isn't the most sophisticated of machine learning algorithms. It's only suitable for problems where you can reasonably assume that every feature is independent. Even in that context, there are other strategies that could yield higher accuracy. <a target="_blank" href="http://blog.aylien.com/naive-bayes-for-dummies-a-simple-explanation/">The characteristics that make Bayes appealing are</a>:

- It generally does a good job, given the right kind of problem.
- It’s relatively simple to understand and build.
- It’s easily trained, even with a small dataset.
- It’s not sensitive to irrelevant features.
- It’s fast!

And that concludes the first installment of _Machine Learning for Mere Mortals_. You can check out the project's full source code <a target="_target" href="https://github.com/nickcherry/ml_naive_bayes">here</a>. Tune in next time for Linear Regressions! :wave:
