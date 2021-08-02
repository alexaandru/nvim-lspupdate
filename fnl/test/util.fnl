((require :test) :lspupdate.util
                 {:lspVal [{:exp [""] :args [""]}
                           {:exp [""] :args [:foo|]}
                           {:exp [:pack1] :args [:foo|pack1]}
                           {:exp [:pack1 :pack2 :pack3]
                            :args ["foo|pack1,pack2,pack3"]}]
                  :flatten [{:exp "" :args [{}]}
                            {:exp :foo :args [[:foo]]}
                            {:exp "foo bar" :args [[:foo :bar]]}
                            {:exp :foo^bar :args [[:foo :bar] "^"]}
                            {:exp "foo bar baz" :args [[:foo [:bar :baz]] " "]}]
                  :osCapture [{:exp "hello world" :args ["echo hello world"]}
                              {:exp :4 :args ["bash -c 'echo $[2+2]'"]}]
                  ;; need more test cases, the ones with no separator/empty string are failing
                  :basename [{:exp :baz.z :args [:foo/bar/baz.z]}
                             {:exp :bar :args [:foo/bar]}]})

