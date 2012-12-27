module Lich
    class Lexer
        EOF = 1
        SIZE = 2
        OPEN_SQUARE_BRACK = 3
        CLOSE_SQUARE_BRACK = 4
        OPEN_BRACE = 5
        CLOSE_BRACE = 6
        OPEN_ANGLE_BRACK = 7
        CLOSE_ANGLE_BRACK = 8
        PAYLOAD = 9

        def initialize input
            @input = input
            @p = 0
            @c = @input[@p]
        end

        def self.token_name type
            case type
            when EOF: 'EOF'
            when SIZE: 'SIZE'
            when OPEN_SQUARE_BRACK: '['
            when CLOSE_SQUARE_BRACK: ']'
            when OPEN_BRACE: '{'
            when CLOSE_BRACE: '}'
            when OPEN_ANGLE_BRACK: '<'
            when CLOSE_ANGLE_BRACK: '>'
            when PAYLOAD: 'PAYLOAD'
            else 'N/A'
            end
        end

        def next_token
            return {:type => EOF, :text => 'EOF'} if @c == -1
            case @c.chr
            when '<': consume; {:type => OPEN_ANGLE_BRACK, :text => '<'}
            when '>': consume; {:type => CLOSE_ANGLE_BRACK, :text => '>'}
            when '[': consume; {:type => OPEN_SQUARE_BRACK, :text => '['}
            when ']': consume; {:type => CLOSE_SQUARE_BRACK, :text => ']'}
            when '{': consume; {:type => OPEN_BRACE, :text => '{'}
            when '}': consume; {:type => CLOSE_BRACE, :text => '}'}
            when '1' .. '9':
                i = @p
                while @c.chr >= '1' and @c.chr <= '9'
                    consume
                end
                {:type => SIZE, :text => @input[i...@p]}
            else
                {:type => EOF, :text =>'<EOF>'} if @c == -1
                i = @p
                while @c != -1 and (@c.chr != '>')
                    consume
                end
                {:type => PAYLOAD, :text => @input[i...@p]}
            end

        end

        private

        def consume
            @p += 1
            if @p >= @input.length
                @c = -1
            else
                @c = @input[@p]
            end
        end



    end

end

lexer = Lich::Lexer.new(ARGV[0])
while (t = lexer.next_token)[:type] != Lich::Lexer::EOF
    puts "#{Lich::Lexer::token_name(t[:type])}: #{t[:text]}"
end
