
module List
    class Token
        EOF = 1
        NAME = 2
        COMMA = 3
        LBRACK = 4
        RBRACK = 5

        NAMES = ['n/a', '<EOF>', 'NAME', 'COMMA', 'LBRACK', 'RBRACK']

        attr_reader :token_type, :text

        def initialize type, text
            @token_type = type
            @text = text
        end

        def to_s
            "<#{@text}, #{NAMES[@token_type]}>"
        end
    end

    class ListLexer

        def initialize s
            @input = s
            @p = 0
            @c = @input[@p]
        end

        def next_token
            while @c != Token::EOF
                case @c.chr
                when ' ': when '\t': when '\r': when '\n':
                    eat_ws
                    next
                when ',':
                    consume
                    return Token.new(Token::COMMA, ',')
                when '[':
                    consume
                    return Token.new(Token::LBRACK, '[')
                when ']':
                    consume
                    return Token.new(Token::RBRACK, ']')
                else
                    return name if is_letter?

                    raise "invalid  character: #{@c.chr}"
                end
            end
            
            Token.new(Token::EOF, nil)
        end
    
        private

        def name
            chars = []
            while is_letter?
                chars << @c.chr
                consume
            end
            Token.new(Token::NAME, chars.join)
        end

        def is_letter?
            (@c >= 'a'[0] and @c <= 'z'[0]) or (@c >= 'A'[0] and @c <= 'Z'[0])
        end

        def consume
            @p += 1
            if @p < @input.length
                @c = @input[@p]
            else
                @c = Token::EOF
            end
        end
            
        def eat_ws
            while @c == ' ' or @c == '\t' or @c == '\n' or @c == '\r'
                consume
            end
        end


    end
end

lexer = List::ListLexer.new(ARGV[0])
while (t = lexer.next_token).token_type != List::Token::EOF
    puts t
end
