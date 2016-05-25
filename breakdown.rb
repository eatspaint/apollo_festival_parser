require 'pry'

class Array
  def mode
    group_by{|i| i}.max{|x,y| x[1].length <=> y[1].length}[0]
  end

  def rm_images
    self.map.with_index do |val, i|
      unless i == self.length - 1
        #don't break at the end
        match = self[i + 1].gsub(/\ /, '')
        #grab the proper element [i+1] and strip out all of the spaces
        self[i] = '' if val.gsub(/\ /, '').gsub(match, '').strip == 'IMAGE'
        #'IMAGE' bit is really popular with somebody making a lot of these sites, i.e. "Foals image FOALS"
      end
    end
    return self.reject {|x| x == ''}
    #kill anything caught by the above loop
  end
end

class String
  def process
    match = /[0-9A-zÀ-ÿ\∆\Λ\&\,\.\!\?\-\+\(\)\$\'\"\”\“\’\®]/
    #any chars that may appear in an artist's name
    regex = /([^\x00-\x7F\u2022\u2023\u25E6\u2043\u2219\,\n]|#{match}+(\ *#{match}+)*)+/
    #matches word groups with common symbols, splits on bullets and non-ascii chars
    list = self.gsub(/\(.*\)/, "").scan(regex).map {|match| match[0]}.reject {|x| x == nil || x.strip == ''}.map {|y| y.strip.upcase}
    #remove paren statements, split via regex, fix ruby's scan result arrays, kill blank results, pull whitespace and upcase for later use
    list.delete(list.mode) if (list.count(list.mode).to_f / list.length) > 0.3
    #yank result if it appears as more than ~1/3 of the entries
    return list.rm_images
  end
end

# full_regex = /([^\x00-\x7F\u2022\u2023\u25E6\u2043\u2219\,\n]|[0-9A-zÀ-ÿ\∆\Λ\&\,\.\!\?\-\+\(\)\$\'\"\”\“\’\®]+(\ *[0-9A-zÀ-ÿ\∆\Λ\&\,\.\!\?\-\+\(\)\$\'\"\”\“\’\®]+)*)+/

# load up example files and parse
# lineups = Dir[File.dirname(__FILE__) + '/lineups/*'].map {|file| File.read(file).process }
# binding.pry
