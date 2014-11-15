require "./WXSniper.rb"
require "./WXSearchSniper.rb"

class WXSniperQueue
  def initialize
    @snipers = []
    @needProcess = false
  end

  def addSniper(sniper)
    @snipers.push(sniper)
    self.setNeedProcessSniper
    puts @snipers
  end

  def setNeedProcessSniper
    @needProcess = true
  end

  def anySinper
    @snipers[-1]
  end

end


queue = WXSniperQueue.new
queue.addSniper(WXSearchSniper.new("hello"))
sniper = queue.anySinper

if sniper == nil
  puts "nil sniper"
else
  items = sniper.process
  items.each{ |x| puts x}

end


