class Test
    def Test.ok(alpha)
        puts alpha
    end

    def Test.retour
        return {alpha: 'a', beta: 'b'}
    end
end

Test.ok(alpha: "ok")

puts Test.retour[:beta]