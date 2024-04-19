# A Telescope plugin work with mpd

**This is just for fun.**

## Motivation

I do love other mpd client, like ncmpcpp, btw, a name my finger can never spell right. However, two things makes me feel bad:

1. I have a lot of Japanese and Chinese songs in my music database. Searching them is never a good idea: I have to open input method, which is a curse in terminal base applications. In fact, I don't want to trigger my input method even in normal GUI apps. Searching Chinese song with `pinyin`, and Japanese ones in `romaji` is **a better idea.**

2. I can never spell the whole word right normally, I know it is my bad, but fuzzy finder works for people like me.

3. I am trying to play with **Neovim** ecosystem. I know I should write a simple shell script with `fzf`, but I just want to explore lua programming. Even thought *Neovim* is not intended and designed to be **a operating system** like *Emacs*, which I never use deeply in fact, *Neovim* GUI, for example *Neovide*, and things like *Neorg* do inspire me to do more things in this amazing editor.

## Work

### Dependency

- mpd, a music daemon
- mpc, a mpd command line client
- python3, and some libraries to generate `pinyin` and `romaji` metadata for your tracks.
- *Neovim*
- telescope.nvim
- plenery.nvim, as a dependency of telescope.nvim, also for testing

### Current State

- a song metadata generator, producing json data
- a picker works with the json metadata, plays the song in mpd immediately, and never clears the queue

### TODO

- [ ] more mpd commands support, like player status, queueing, playlist
- [ ] more sensible metadata gnerator
- [ ] a real text base UI in *Neovim* with *Neovim* APIs
- [ ] learn lua FFI to work directly with mpc C binding

## References

- [Thank *Developer Voices* for amazing video to write a simple telescope plugin, also the amazing debug skills](https://www.youtube.com/watch?v=HXABdG3xJW4)
- [Telescope Official Developer Guide](https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md)
- [*Neovim* lua guide](https://github.com/nanotee/nvim-lua-guide)
- [special thanks to TJ, he is always my hero. Great *Neovim* contents on his youtube channel, you can also watch TJ's stream on Twitch too](https://www.youtube.com/@teej_dv)
