# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Misc

    $cbot.add_command(:donators,
       code: proc { |event, args|
         user = Helper.userparse(args[1])
         id = user.id rescue nil
         if args[0] == 'add'
           if user.nil?
             event.respond("#{YuukiBot.config['emoji_error']} Not a valid user!")
             next
           end
           donators = JSON.parse(REDIS.get('donators')) rescue []
           if donators.include?(id)
             event.respond("#{YuukiBot.config['emoji_error']} User is already a donator!")
             next
           end
           REDIS.set('donators', donators.push(id).to_json)
           event.respond("#{YuukiBot.config['emoji_tickbox']} added `#{event.bot.user(id).nil? ? "Unknown User (ID: #{id})" : "#{event.bot.user(id).distinct}"}` to donators!")
         elsif args[0] == 'remove'
           if user.nil?
             event.respond("#{YuukiBot.config['emoji_error']} Not a valid user!")
             next
           end
           donators = JSON.parse(REDIS.get('donators')) rescue []
           unless donators.include?(id)
             event.respond("#{YuukiBot.config['emoji_error']} User is not a donator!")
             next
           end
           REDIS.set('donators', donators.delete(id).to_json)
           event.respond("#{YuukiBot.config['emoji_tickbox']} removed `#{event.bot.user(id).nil? ? "Unknown User (ID: #{id})" : "#{event.bot.user(id).distinct}"}` from donators!")
         else
           if YuukiBot.config['show_donate_urls']
             event << "💰 Hey, making bots and hosting them isn't free. If you want this bot to stay alive, consider giving some 💵 to the devs: "
             YuukiBot.config['donate_urls'].each {|url| event << "- #{url}" }
             event << '__**Donators ❤️**__ (aka the best people ever)'
             donators = JSON.parse(REDIS.get('donators')) rescue []
             if donators.length > 0
               donators.each {|x|
                 event.bot.user(x).nil? ? event << "- Unknown User (ID: `#{x}`)" : event << "- **#{event.bot.user(x).distinct}**"
               }
             else
               event << 'None! You can be the first! :)'
             end
           else
             event << 'Sorry, donation information has been disabled for this bot instance!'
             event << 'Please contact the bot owner for more information.'
           end
         end
       },
       owners_only: true,
       failcode: proc { |event, _|
         if YuukiBot.config['show_donate_urls']
           event << "💰 Hey, making bots and hosting them isn't free. If you want this bot to stay alive, consider giving some 💵 to the devs: "
           YuukiBot.config['donate_urls'].each {|url| event << "- #{url}" }
           event << '__**Donators ❤️*__ (aka the best people ever)'
           donators = JSON.parse(REDIS.get('donators')) rescue []
           if donators.length > 0
             donators.each {|x|
               event.bot.user(x).nil? ? event << "- Unknown User (ID: `#{x}`)" : event << "- **#{event.bot.user(x).distinct}**"
             }
           else
             event << 'None! You can be the first! :)'
           end
         else
           event << 'Sorry, donation information has been disabled for this bot instance!'
           event << 'Please contact the bot owner for more information.'
         end
       }
    )

    $cbot.add_command(:donate,
      code: proc {|event,args|
        if YuukiBot.config['show_donate_urls']
          event << "💰 Hey, making bots and hosting them isn't free. If you want this bot to stay alive, consider giving some 💵 to the devs: "
          YuukiBot.config['donate_urls'].each {|url| event << "- #{url}" }
          event << '__**Donators :heart:**__ (aka the best people ever)'
          donators = JSON.parse(REDIS.get('donators')) rescue []
          if donators.length > 0
            donators.each {|x|
              event.bot.user(x).nil? ? event << "- Unknown User (ID: `#{x}`)" : event << "- **#{event.bot.user(x).distinct}**"
            }
          else
            event << 'None! You can be the first! :)'
          end
        else
          event << 'Sorry, donation information has been disabled for this bot instance!'
          event << 'Please contact the bot owner for more information.'
        end
      },
      triggers: ['donate', 'donateinfo', 'how do i donate', 'how do i donate?', 'how do I donate', 'how do I donate?', 'doante', 'donut']
    )

  end
end
