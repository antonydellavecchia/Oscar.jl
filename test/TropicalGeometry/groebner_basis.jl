@testset "groebner_basis" begin
    @testset "Cyclic5Homogenized" begin
        Kx,(x0,x1,x2,x3,x4,x5) = PolynomialRing(QQ,6)
        Cyclic5Homogenized = ideal([x1+x2+x3+x4+x5,
                                   x1*x2+x2*x3+x3*x4+x1*x5+x4*x5,
                                   x1*x2*x3+x2*x3*x4+x1*x2*x5+x1*x4*x5+x3*x4*x5,
                                   x1*x2*x3*x4+x1*x2*x3*x5+x1*x2*x4*x5+x1*x3*x4*x5+x2*x3*x4*x5,
                                   -x0^5+x1*x2*x3*x4*x5])
        w = [0,0,0,0,0,0]
        @testset "val_2" begin
            val_2 = TropicalSemiringMap(QQ,2)
            computed = groebner_basis(Cyclic5Homogenized, val_2, w, complete_reduction=true)
            # Apparently the Groebner basis lives in a different ring, so we have
            # to hack around this...
            computed_ring = parent(computed[1])
            (y1, y2, y3, y4, y5, y6) = gens(computed_ring)
            expected = [y3*y4*y5^2 + y3*y4*y5*y6 - y3*y4*y6^2 - y3*y5^2*y6 - y3*y5*y6^2 + y3*y6^3 + y4^2*y5*y6 + y4*y5^2*y6 + y4*y6^3 - y5^3*y6 - 2*y5^2*y6^2 - y5*y6^3 + y6^4
     y3*y4^2 - y3*y4*y5 + y3*y5*y6 - y3*y6^2 + y4^2*y5 - y4^2*y6 + y4*y5*y6 - 2*y4*y6^2 + y5^2*y6 + y5*y6^2 - y6^3
     -2*y3*y4*y5*y6^2 + 3*y3*y4*y6^3 - y3*y5^3*y6 - y3*y5^2*y6^2 + 2*y3*y5*y6^3 - y3*y6^4 + y4^2*y5^3 - y4^2*y5*y6^2 + y4^2*y6^3 - 2*y4*y5^2*y6^2 + 4*y4*y5*y6^3 - y5^4*y6 - 3*y5^3*y6^2 - y5^2*y6^3 + 3*y5*y6^4 - y6^5
     -11*y3*y4*y5*y6^4 - 6*y3*y4*y6^5 - 19*y3*y5^3*y6^3 + 16*y3*y5^2*y6^4 + 46*y3*y5*y6^5 - 26*y3*y6^6 - 6*y4^3*y6^4 - y4^2*y5*y6^4 - 28*y4^2*y6^5 + 16*y4*y5^3*y6^3 - 9*y4*y5^2*y6^4 + 19*y4*y5*y6^5 - 48*y4*y6^6 + y5^5*y6^2 - 9*y5^4*y6^3 + 7*y5^3*y6^4 + 48*y5^2*y6^5 + 36*y5*y6^6 - 26*y6^7
     -y3*y4*y5*y6 - y3*y4*y6^2 + y3*y5^2*y6 + 4*y3*y5*y6^2 - 3*y3*y6^3 + y4^3*y5 - y4^3*y6 - y4^2*y5^2 + 3*y4^2*y5*y6 - 4*y4^2*y6^2 + 2*y4*y5*y6^2 - 6*y4*y6^3 + y5^3*y6 + 5*y5^2*y6^2 + 3*y5*y6^3 - 3*y6^4
     -4*y3*y4*y5*y6^3 + 21*y3*y4*y6^4 - 3*y3*y5^3*y6^2 - 15*y3*y5^2*y6^3 - 12*y3*y5*y6^4 + 13*y3*y6^5 + y4^4*y6^2 + 9*y4^3*y6^3 - 3*y4^2*y5*y6^3 + 32*y4^2*y6^4 - 16*y4*y5^3*y6^2 - 16*y4*y5^2*y6^3 + 14*y4*y5*y6^4 + 37*y4*y6^5 - 4*y5^4*y6^2 - 28*y5^3*y6^3 - 37*y5^2*y6^4 - 2*y5*y6^5 + 13*y6^6
     y3^2 + y3*y5 + 2*y3*y6 - y4*y5 + y4*y6 + y6^2
     2*y3*y4*y6^4 + 4*y3*y5^3*y6^2 - 2*y3*y5^2*y6^3 - 8*y3*y5*y6^4 + 4*y3*y6^5 + y4^3*y6^3 - y4^2*y5*y6^3 + 5*y4^2*y6^4 + y4*y5^4*y6 - 3*y4*y5^3*y6^2 - 4*y4*y5*y6^4 + 8*y4*y6^5 + 3*y5^4*y6^2 - 8*y5^2*y6^4 - 6*y5*y6^5 + 4*y6^6
     -y3*y4*y5*y6^2 + 4*y3*y4*y6^3 - y3*y5^3*y6 - 2*y3*y5^2*y6^2 - 2*y3*y5*y6^3 + 2*y3*y6^4 + y4^3*y6^2 + y4^2*y5^2*y6 - y4^2*y5*y6^2 + 5*y4^2*y6^3 - 3*y4*y5^3*y6 - 2*y4*y5^2*y6^2 + 3*y4*y5*y6^3 + 6*y4*y6^4 - y5^4*y6 - 5*y5^3*y6^2 - 6*y5^2*y6^3 + 2*y6^5
     y1^5 - 2*y3*y4*y5*y6^2 + y3*y4*y6^3 + 2*y3*y5*y6^3 - y3*y6^4 - y4^2*y5*y6^2 - 2*y4*y5^2*y6^2 + y4*y5*y6^3 - y4*y6^4 + y5^2*y6^3 + 2*y5*y6^4 - y6^5
     -8*y3*y4*y5*y6^3 - 3*y3*y4*y6^4 + y3*y5^4*y6 - 11*y3*y5^3*y6^2 + 9*y3*y5^2*y6^3 + 29*y3*y5*y6^4 - 17*y3*y6^5 - 4*y4^3*y6^3 - y4^2*y5*y6^3 - 18*y4^2*y6^4 + 11*y4*y5^3*y6^2 - 6*y4*y5^2*y6^3 + 12*y4*y5*y6^4 - 31*y4*y6^5 + y5^5*y6 - 5*y5^4*y6^2 + 5*y5^3*y6^3 + 30*y5^2*y6^4 + 23*y5*y6^5 - 17*y6^6
     y2 + y3 + y4 + y5 + y6]
            @test computed == expected
        end

        @testset "val_3" begin
            val_3 = TropicalSemiringMap(QQ,3)
            computed = groebner_basis(Cyclic5Homogenized, val_3, w, complete_reduction=true)
            # Apparently the Groebner basis lives in a different ring, so we have
            # to hack around this...
            computed_ring = parent(computed[1])
            (y1, y2, y3, y4, y5, y6) = gens(computed_ring)
            expected = [-2*y3*y4*y5*y6^2 + 3*y3*y4*y6^3 - y3*y5^3*y6 - y3*y5^2*y6^2 + 2*y3*y5*y6^3 - y3*y6^4 + y4^2*y5^3 - y4^2*y5*y6^2 + y4^2*y6^3 - 2*y4*y5^2*y6^2 + 4*y4*y5*y6^3 - y5^4*y6 - 3*y5^3*y6^2 - y5^2*y6^3 + 3*y5*y6^4 - y6^5
 -11*y3*y4*y5*y6^4 - 6*y3*y4*y6^5 - 19*y3*y5^3*y6^3 + 16*y3*y5^2*y6^4 + 46*y3*y5*y6^5 - 26*y3*y6^6 - 6*y4^3*y6^4 - y4^2*y5*y6^4 - 28*y4^2*y6^5 + 16*y4*y5^3*y6^3 - 9*y4*y5^2*y6^4 + 19*y4*y5*y6^5 - 48*y4*y6^6 + y5^5*y6^2 - 9*y5^4*y6^3 + 7*y5^3*y6^4 + 48*y5^2*y6^5 + 36*y5*y6^6 - 26*y6^7
 -y3*y4*y5*y6^2 + 4*y3*y4*y6^3 - y3*y5^3*y6 - 2*y3*y5^2*y6^2 - 2*y3*y5*y6^3 + 2*y3*y6^4 + y4^3*y6^2 + y4^2*y5^2*y6 - y4^2*y5*y6^2 + 5*y4^2*y6^3 - 3*y4*y5^3*y6 - 2*y4*y5^2*y6^2 + 3*y4*y5*y6^3 + 6*y4*y6^4 - y5^4*y6 - 5*y5^3*y6^2 - 6*y5^2*y6^3 + 2*y6^5
 2*y3*y4*y6^4 + 4*y3*y5^3*y6^2 - 2*y3*y5^2*y6^3 - 8*y3*y5*y6^4 + 4*y3*y6^5 + y4^3*y6^3 - y4^2*y5*y6^3 + 5*y4^2*y6^4 + y4*y5^4*y6 - 3*y4*y5^3*y6^2 - 4*y4*y5*y6^4 + 8*y4*y6^5 + 3*y5^4*y6^2 - 8*y5^2*y6^4 - 6*y5*y6^5 + 4*y6^6
 -y3*y4*y5*y6 - y3*y4*y6^2 + y3*y5^2*y6 + 4*y3*y5*y6^2 - 3*y3*y6^3 + y4^3*y5 - y4^3*y6 - y4^2*y5^2 + 3*y4^2*y5*y6 - 4*y4^2*y6^2 + 2*y4*y5*y6^2 - 6*y4*y6^3 + y5^3*y6 + 5*y5^2*y6^2 + 3*y5*y6^3 - 3*y6^4
 -4*y3*y4*y5*y6^3 + 21*y3*y4*y6^4 - 3*y3*y5^3*y6^2 - 15*y3*y5^2*y6^3 - 12*y3*y5*y6^4 + 13*y3*y6^5 + y4^4*y6^2 + 9*y4^3*y6^3 - 3*y4^2*y5*y6^3 + 32*y4^2*y6^4 - 16*y4*y5^3*y6^2 - 16*y4*y5^2*y6^3 + 14*y4*y5*y6^4 + 37*y4*y6^5 - 4*y5^4*y6^2 - 28*y5^3*y6^3 - 37*y5^2*y6^4 - 2*y5*y6^5 + 13*y6^6
 -8*y3*y4*y5*y6^3 - 3*y3*y4*y6^4 + y3*y5^4*y6 - 11*y3*y5^3*y6^2 + 9*y3*y5^2*y6^3 + 29*y3*y5*y6^4 - 17*y3*y6^5 - 4*y4^3*y6^3 - y4^2*y5*y6^3 - 18*y4^2*y6^4 + 11*y4*y5^3*y6^2 - 6*y4*y5^2*y6^3 + 12*y4*y5*y6^4 - 31*y4*y6^5 + y5^5*y6 - 5*y5^4*y6^2 + 5*y5^3*y6^3 + 30*y5^2*y6^4 + 23*y5*y6^5 - 17*y6^6
 y3*y4*y5^2 + y3*y4*y5*y6 - y3*y4*y6^2 - y3*y5^2*y6 - y3*y5*y6^2 + y3*y6^3 + y4^2*y5*y6 + y4*y5^2*y6 + y4*y6^3 - y5^3*y6 - 2*y5^2*y6^2 - y5*y6^3 + y6^4
 y3*y4^2 - y3*y4*y5 + y3*y5*y6 - y3*y6^2 + y4^2*y5 - y4^2*y6 + y4*y5*y6 - 2*y4*y6^2 + y5^2*y6 + y5*y6^2 - y6^3
 y3^2 + y3*y5 + 2*y3*y6 - y4*y5 + y4*y6 + y6^2
 y2 + y3 + y4 + y5 + y6
 y1^5 - 2*y3*y4*y5*y6^2 + y3*y4*y6^3 + 2*y3*y5*y6^3 - y3*y6^4 - y4^2*y5*y6^2 - 2*y4*y5^2*y6^2 + y4*y5*y6^3 - y4*y6^4 + y5^2*y6^3 + 2*y5*y6^4 - y6^5]
            @test computed == expected
        end
    end

    @testset "Katsura5Homogenized" begin
        Kx,(x0,x1,x2,x3,x4,x5) = PolynomialRing(QQ,6)
        Katsura5Homogenized = ideal([-x0+x1+2*x2+2*x3+2*x4+2*x5,
                                    -x0*x1+x1^2+2*x2^2+2*x3^2+2*x4^2+2*x5^2,
                                    -x0*x2+2*x1*x2+2*x2*x3+2*x3*x4+2*x4*x5,
                                    x2^2-x0*x3+2*x1*x3+2*x2*x4+2*x3*x5,
                                    2*x2*x3-x0*x4+2*x1*x4+2*x2*x5])
        w = [0,0,0,0,0,0]
        @testset "val_2" begin
            val_2 = TropicalSemiringMap(QQ,2)
            computed = groebner_basis(Katsura5Homogenized, val_2, w, complete_reduction=true)
            # Apparently the Groebner basis lives in a different ring, so we have
            # to hack around this...
            computed_ring = parent(computed[1])
            (y1, y2, y3, y4, y5, y6) = gens(computed_ring)
            expected = [y2^4*y6 - 311*y2^3*y6^2 - 3480*y2^2*y6^3 - 1234*y2*y4*y6^3 - 5*y2*y5^2*y6^2 - 1162*y2*y5*y6^3 - 7542*y2*y6^4 + 8586*y3*y5^2*y6^2 - 39118*y3*y5*y6^3 - 6120*y3*y6^4 - 1660*y4*y5^2*y6^2 + 2232*y4*y5*y6^3 - 5060*y4*y6^4 + 1172*y5^4*y6 - 3110*y5^3*y6^2 + 1416*y5^2*y6^3 + 2176*y5*y6^4 + 11332*y6^5
 10*y2^2*y6 - 6*y2*y4*y6 + 37*y2*y5^2 - 2*y2*y5*y6 + 18*y2*y6^2 - 98*y3*y5^2 + 118*y3*y5*y6 + 24*y3*y6^2 - 124*y4*y5^2 + 24*y4*y5*y6 + 20*y4*y6^2 - 74*y5^3 - 112*y5^2*y6 + 8*y5*y6^2 - 28*y6^3
 -1957*y2^3*y6 - 20993*y2^2*y6^2 - 8830*y2*y4*y6^2 + 8*y2*y5^2*y6 - 7894*y2*y5*y6^2 - 47370*y2*y6^3 + 52136*y3*y5^2*y6 - 241980*y3*y5*y6^2 - 37832*y3*y6^3 - 9540*y4*y5^2*y6 + 12936*y4*y5*y6^2 - 30244*y4*y6^3 + 7194*y5^4 - 18880*y5^3*y6 + 9076*y5^2*y6^2 + 13928*y5*y6^3 + 70320*y6^4
 1957*y2^3*y5*y6 + 2016*y2^3*y6^2 + 20993*y2^2*y5*y6^2 + 25242*y2^2*y6^3 + 8830*y2*y4*y5*y6^2 + 19082*y2*y4*y6^3 - 8*y2*y5^3*y6 + 7891*y2*y5^2*y6^2 + 71922*y2*y5*y6^3 + 79618*y2*y6^4 - 52136*y3*y5^3*y6 + 237110*y3*y5^2*y6^2 + 376690*y3*y5*y6^3 + 40856*y3*y6^4 + 9540*y4*y5^3*y6 + 14892*y4*y5^2*y6^2 + 22220*y4*y5*y6^3 + 38388*y4*y6^4 + 18528*y5^4*y6 + 57614*y5^3*y6^2 + 34908*y5^2*y6^3 - 102196*y5*y6^4 - 106876*y6^5
 8882351160*y2^3*y6 + 95295775448*y2^2*y6^2 + 40069075092*y2*y4*y6^2 + y2*y5^3 + 14046703*y2*y5^2*y6 + 35826240740*y2*y5*y6^2 + 215025506808*y2*y6^3 - 236766111212*y3*y5^2*y6 + 1098449475000*y3*y5*y6^2 + 171742990416*y3*y6^3 + 43130996630*y4*y5^2*y6 - 58680721228*y4*y5*y6^2 + 137297443936*y4*y6^3 - 32651831500*y5^4 + 85591054414*y5^3*y6 - 41346207054*y5^2*y6^2 - 63204945956*y5*y6^3 - 319203633416*y6^4
 8220*y2^3*y6 + 88190*y2^2*y6^2 + 37082*y2*y4*y6^2 + 13*y2*y5^2*y6 + 33156*y2*y5*y6^2 + 198994*y2*y6^3 - 219108*y3*y5^2*y6 + 1016546*y3*y5*y6^2 + 158936*y3*y6^3 + 2*y4*y5^3 + 39916*y4*y5^2*y6 - 54304*y4*y5*y6^2 + 127060*y4*y6^3 - 30216*y5^4 + 79212*y5^3*y6 - 38260*y5^2*y6^2 - 58492*y5*y6^3 - 295404*y6^4
 -2*y2^2*y6 + y2*y4*y5 + 2*y2*y4*y6 - 6*y2*y5^2 + 3*y2*y5*y6 - 2*y2*y6^2 + 22*y3*y5^2 - 18*y3*y5*y6 - 4*y3*y6^2 + 24*y4*y5^2 - 4*y4*y5*y6 - 4*y4*y6^2 + 14*y5^3 + 20*y5^2*y6 - 4*y5*y6^2 + 4*y6^3
 y1 - y2 - 2*y3 - 2*y4 - 2*y5 - 2*y6
 y2*y6 + 2*y3*y5 + y4^2 + 2*y4*y5 + y5^2 - y6^2
 y2*y4 + y2*y5 + 2*y2*y6 + y3^2 + 4*y3*y5 + 2*y3*y6 - 2*y5*y6 - 2*y6^2
 y2^2*y4 + 2*y2^2*y6 + 2*y2*y4*y6 + 9*y2*y5^2 - 6*y2*y5*y6 + 2*y2*y6^2 - 34*y3*y5^2 + 16*y3*y5*y6 + 8*y3*y6^2 - 50*y4*y5^2 + 8*y4*y5*y6 - 26*y5^3 - 38*y5^2*y6 + 8*y5*y6^2 - 4*y6^3
 y2^2*y5 + 4*y2^2*y6 - 4*y2*y4*y6 + 10*y2*y5^2 + 2*y2*y5*y6 + 4*y2*y6^2 - 16*y3*y5^2 + 40*y3*y5*y6 + 8*y3*y6^2 - 24*y4*y5^2 + 4*y4*y5*y6 + 8*y4*y6^2 - 16*y5^3 - 28*y5^2*y6 - 4*y5*y6^2 - 8*y6^3
 y2*y5 + 2*y3*y4 - 2*y3*y5 + 2*y3*y6 - 2*y4*y5 - 2*y5^2 - 2*y5*y6
 y2*y3 + 2*y2*y4 + 2*y2*y5 + 4*y2*y6 + 6*y3*y5 + 2*y3*y6 + 2*y4*y5 - 2*y5*y6 - 4*y6^2
 54153360*y2^3*y6 + 580993291*y2^2*y6^2 + 244290617*y2*y4*y6^2 + 85639*y2*y5^2*y6 + 218423171*y2*y5*y6^2 + 1310953987*y2*y6^3 + y3*y5^3 - 1443500738*y3*y5^2*y6 + 6696957681*y3*y5*y6^2 + 1047071864*y3*y6^3 + 262958349*y4*y5^2*y6 - 357760932*y4*y5*y6^2 + 837066422*y4*y6^3 - 199069633*y5^4 + 521826158*y5^3*y6 - 252076955*y5^2*y6^2 - 385343940*y5*y6^3 - 1946100638*y6^4]
            @test computed == expected
        end
        
        @testset "val_3" begin
            val_3 = TropicalSemiringMap(QQ,3)
            computed = groebner_basis(Katsura5Homogenized, val_3, w, complete_reduction=true)
            # Apparently the Groebner basis lives in a different ring, so we have
            # to hack around this...
            computed_ring = parent(computed[1])
            (y1, y2, y3, y4, y5, y6) = gens(computed_ring)
            expected = [8882351160*y2^3*y6 + 95295775448*y2^2*y6^2 + 40069075092*y2*y4*y6^2 + y2*y5^3 + 14046703*y2*y5^2*y6 + 35826240740*y2*y5*y6^2 + 215025506808*y2*y6^3 - 236766111212*y3*y5^2*y6 + 1098449475000*y3*y5*y6^2 + 171742990416*y3*y6^3 + 43130996630*y4*y5^2*y6 - 58680721228*y4*y5*y6^2 + 137297443936*y4*y6^3 - 32651831500*y5^4 + 85591054414*y5^3*y6 - 41346207054*y5^2*y6^2 - 63204945956*y5*y6^3 - 319203633416*y6^4
 2016*y2^3*y6^2 + 25242*y2^2*y6^3 + 19082*y2*y4*y6^3 - 3*y2*y5^2*y6^2 + 24552*y2*y5*y6^3 + 79618*y2*y6^4 - 4870*y3*y5^2*y6^2 + 338858*y3*y5*y6^3 + 40856*y3*y6^4 + 27828*y4*y5^2*y6^2 - 8024*y4*y5*y6^3 + 38388*y4*y6^4 + 7194*y5^5 - 352*y5^4*y6 + 66690*y5^3*y6^2 + 48836*y5^2*y6^3 - 31876*y5*y6^4 - 106876*y6^5
 y2^2*y5 + 4*y2^2*y6 - 4*y2*y4*y6 + 10*y2*y5^2 + 2*y2*y5*y6 + 4*y2*y6^2 - 16*y3*y5^2 + 40*y3*y5*y6 + 8*y3*y6^2 - 24*y4*y5^2 + 4*y4*y5*y6 + 8*y4*y6^2 - 16*y5^3 - 28*y5^2*y6 - 4*y5*y6^2 - 8*y6^3
 -1957*y2^3*y6 - 20993*y2^2*y6^2 - 8830*y2*y4*y6^2 + 8*y2*y5^2*y6 - 7894*y2*y5*y6^2 - 47370*y2*y6^3 + 52136*y3*y5^2*y6 - 241980*y3*y5*y6^2 - 37832*y3*y6^3 - 9540*y4*y5^2*y6 + 12936*y4*y5*y6^2 - 30244*y4*y6^3 + 7194*y5^4 - 18880*y5^3*y6 + 9076*y5^2*y6^2 + 13928*y5*y6^3 + 70320*y6^4
 y2*y6 + 2*y3*y5 + y4^2 + 2*y4*y5 + y5^2 - y6^2
 y2*y3 + 2*y2*y4 + 2*y2*y5 + 4*y2*y6 + 6*y3*y5 + 2*y3*y6 + 2*y4*y5 - 2*y5*y6 - 4*y6^2
 -2*y2^2*y6 + y2*y4*y5 + 2*y2*y4*y6 - 6*y2*y5^2 + 3*y2*y5*y6 - 2*y2*y6^2 + 22*y3*y5^2 - 18*y3*y5*y6 - 4*y3*y6^2 + 24*y4*y5^2 - 4*y4*y5*y6 - 4*y4*y6^2 + 14*y5^3 + 20*y5^2*y6 - 4*y5*y6^2 + 4*y6^3
 y2^4*y6 - 311*y2^3*y6^2 - 3480*y2^2*y6^3 - 1234*y2*y4*y6^3 - 5*y2*y5^2*y6^2 - 1162*y2*y5*y6^3 - 7542*y2*y6^4 + 8586*y3*y5^2*y6^2 - 39118*y3*y5*y6^3 - 6120*y3*y6^4 - 1660*y4*y5^2*y6^2 + 2232*y4*y5*y6^3 - 5060*y4*y6^4 + 1172*y5^4*y6 - 3110*y5^3*y6^2 + 1416*y5^2*y6^3 + 2176*y5*y6^4 + 11332*y6^5
 y2*y5 + 2*y3*y4 - 2*y3*y5 + 2*y3*y6 - 2*y4*y5 - 2*y5^2 - 2*y5*y6
 y2*y4 + y2*y5 + 2*y2*y6 + y3^2 + 4*y3*y5 + 2*y3*y6 - 2*y5*y6 - 2*y6^2
 10*y2^2*y6 - 6*y2*y4*y6 + 37*y2*y5^2 - 2*y2*y5*y6 + 18*y2*y6^2 - 98*y3*y5^2 + 118*y3*y5*y6 + 24*y3*y6^2 - 124*y4*y5^2 + 24*y4*y5*y6 + 20*y4*y6^2 - 74*y5^3 - 112*y5^2*y6 + 8*y5*y6^2 - 28*y6^3
 8220*y2^3*y6 + 88190*y2^2*y6^2 + 37082*y2*y4*y6^2 + 13*y2*y5^2*y6 + 33156*y2*y5*y6^2 + 198994*y2*y6^3 - 219108*y3*y5^2*y6 + 1016546*y3*y5*y6^2 + 158936*y3*y6^3 + 2*y4*y5^3 + 39916*y4*y5^2*y6 - 54304*y4*y5*y6^2 + 127060*y4*y6^3 - 30216*y5^4 + 79212*y5^3*y6 - 38260*y5^2*y6^2 - 58492*y5*y6^3 - 295404*y6^4
 y2^2*y4 + 2*y2^2*y6 + 2*y2*y4*y6 + 9*y2*y5^2 - 6*y2*y5*y6 + 2*y2*y6^2 - 34*y3*y5^2 + 16*y3*y5*y6 + 8*y3*y6^2 - 50*y4*y5^2 + 8*y4*y5*y6 - 26*y5^3 - 38*y5^2*y6 + 8*y5*y6^2 - 4*y6^3
 54153360*y2^3*y6 + 580993291*y2^2*y6^2 + 244290617*y2*y4*y6^2 + 85639*y2*y5^2*y6 + 218423171*y2*y5*y6^2 + 1310953987*y2*y6^3 + y3*y5^3 - 1443500738*y3*y5^2*y6 + 6696957681*y3*y5*y6^2 + 1047071864*y3*y6^3 + 262958349*y4*y5^2*y6 - 357760932*y4*y5*y6^2 + 837066422*y4*y6^3 - 199069633*y5^4 + 521826158*y5^3*y6 - 252076955*y5^2*y6^2 - 385343940*y5*y6^3 - 1946100638*y6^4
 y1 - y2 - 2*y3 - 2*y4 - 2*y5 - 2*y6]
            @test computed == expected
        end
    end

    @testset "val_t" begin
        Kt,t = RationalFunctionField(QQ,"t")
        Ktx,(x0,x1,x2,x3,x4,x5) = PolynomialRing(Kt,6)
        Cyclic5Homogenized = ideal([x1+x2+x3+x4+x5,
                                   x1*x2+x2*x3+x3*x4+x1*x5+x4*x5,
                                   x1*x2*x3+x2*x3*x4+x1*x2*x5+x1*x4*x5+x3*x4*x5,
                                   x1*x2*x3*x4+x1*x2*x3*x5+x1*x2*x4*x5+x1*x3*x4*x5+x2*x3*x4*x5,
                                   -x0^5+x1*x2*x3*x4*x5])
        Katsura5Homogenized = ideal([-x0+x1+2*x2+2*x3+2*x4+2*x5,
                                    -x0*x1+x1^2+2*x2^2+2*x3^2+2*x4^2+2*x5^2,
                                    -x0*x2+2*x1*x2+2*x2*x3+2*x3*x4+2*x4*x5,
                                    x2^2-x0*x3+2*x1*x3+2*x2*x4+2*x3*x5,
                                    2*x2*x3-x0*x4+2*x1*x4+2*x2*x5])
        w = [0,0,0,0,0,0]
        val_t = TropicalSemiringMap(Kt,t)
        @testset "Cyclic5Homogenized" begin
            computed = groebner_basis(Cyclic5Homogenized, val_t, w, complete_reduction=true)
            # Apparently the Groebner basis lives in a different ring, so we have
            # to hack around this...
            computed_ring = parent(computed[1])
            (y1, y2, y3, y4, y5, y6) = gens(computed_ring)
            expected = [11*y3*y4*y5*y6^4 + 6*y3*y4*y6^5 + 19*y3*y5^3*y6^3 - 16*y3*y5^2*y6^4 - 46*y3*y5*y6^5 + 26*y3*y6^6 + 6*y4^3*y6^4 + y4^2*y5*y6^4 + 28*y4^2*y6^5 - 16*y4*y5^3*y6^3 + 9*y4*y5^2*y6^4 - 19*y4*y5*y6^5 + 48*y4*y6^6 - y5^5*y6^2 + 9*y5^4*y6^3 - 7*y5^3*y6^4 - 48*y5^2*y6^5 - 36*y5*y6^6 + 26*y6^7
 -2*y3*y4*y6^4 - 4*y3*y5^3*y6^2 + 2*y3*y5^2*y6^3 + 8*y3*y5*y6^4 - 4*y3*y6^5 - y4^3*y6^3 + y4^2*y5*y6^3 - 5*y4^2*y6^4 - y4*y5^4*y6 + 3*y4*y5^3*y6^2 + 4*y4*y5*y6^4 - 8*y4*y6^5 - 3*y5^4*y6^2 + 8*y5^2*y6^4 + 6*y5*y6^5 - 4*y6^6
 y3*y4*y5*y6^2 - 4*y3*y4*y6^3 + y3*y5^3*y6 + 2*y3*y5^2*y6^2 + 2*y3*y5*y6^3 - 2*y3*y6^4 - y4^3*y6^2 - y4^2*y5^2*y6 + y4^2*y5*y6^2 - 5*y4^2*y6^3 + 3*y4*y5^3*y6 + 2*y4*y5^2*y6^2 - 3*y4*y5*y6^3 - 6*y4*y6^4 + y5^4*y6 + 5*y5^3*y6^2 + 6*y5^2*y6^3 - 2*y6^5
 2*y3*y4*y5*y6^2 - 3*y3*y4*y6^3 + y3*y5^3*y6 + y3*y5^2*y6^2 - 2*y3*y5*y6^3 + y3*y6^4 - y4^2*y5^3 + y4^2*y5*y6^2 - y4^2*y6^3 + 2*y4*y5^2*y6^2 - 4*y4*y5*y6^3 + y5^4*y6 + 3*y5^3*y6^2 + y5^2*y6^3 - 3*y5*y6^4 + y6^5
 -y3*y4*y5*y6 - y3*y4*y6^2 + y3*y5^2*y6 + 4*y3*y5*y6^2 - 3*y3*y6^3 + y4^3*y5 - y4^3*y6 - y4^2*y5^2 + 3*y4^2*y5*y6 - 4*y4^2*y6^2 + 2*y4*y5*y6^2 - 6*y4*y6^3 + y5^3*y6 + 5*y5^2*y6^2 + 3*y5*y6^3 - 3*y6^4
 4*y3*y4*y5*y6^3 - 21*y3*y4*y6^4 + 3*y3*y5^3*y6^2 + 15*y3*y5^2*y6^3 + 12*y3*y5*y6^4 - 13*y3*y6^5 - y4^4*y6^2 - 9*y4^3*y6^3 + 3*y4^2*y5*y6^3 - 32*y4^2*y6^4 + 16*y4*y5^3*y6^2 + 16*y4*y5^2*y6^3 - 14*y4*y5*y6^4 - 37*y4*y6^5 + 4*y5^4*y6^2 + 28*y5^3*y6^3 + 37*y5^2*y6^4 + 2*y5*y6^5 - 13*y6^6
 8*y3*y4*y5*y6^3 + 3*y3*y4*y6^4 - y3*y5^4*y6 + 11*y3*y5^3*y6^2 - 9*y3*y5^2*y6^3 - 29*y3*y5*y6^4 + 17*y3*y6^5 + 4*y4^3*y6^3 + y4^2*y5*y6^3 + 18*y4^2*y6^4 - 11*y4*y5^3*y6^2 + 6*y4*y5^2*y6^3 - 12*y4*y5*y6^4 + 31*y4*y6^5 - y5^5*y6 + 5*y5^4*y6^2 - 5*y5^3*y6^3 - 30*y5^2*y6^4 - 23*y5*y6^5 + 17*y6^6
 y3*y4*y5^2 + y3*y4*y5*y6 - y3*y4*y6^2 - y3*y5^2*y6 - y3*y5*y6^2 + y3*y6^3 + y4^2*y5*y6 + y4*y5^2*y6 + y4*y6^3 - y5^3*y6 - 2*y5^2*y6^2 - y5*y6^3 + y6^4
 -y3*y4^2 + y3*y4*y5 - y3*y5*y6 + y3*y6^2 - y4^2*y5 + y4^2*y6 - y4*y5*y6 + 2*y4*y6^2 - y5^2*y6 - y5*y6^2 + y6^3
 -y3^2 - y3*y5 - 2*y3*y6 + y4*y5 - y4*y6 - y6^2
 y2 + y3 + y4 + y5 + y6
 -y1^5 + 2*y3*y4*y5*y6^2 - y3*y4*y6^3 - 2*y3*y5*y6^3 + y3*y6^4 + y4^2*y5*y6^2 + 2*y4*y5^2*y6^2 - y4*y5*y6^3 + y4*y6^4 - y5^2*y6^3 - 2*y5*y6^4 + y6^5]
            @test computed == expected
        end

        @testset "Katsura5Homogenized" begin
            computed = groebner_basis(Katsura5Homogenized, val_t, w, complete_reduction=true)
            # Apparently the Groebner basis lives in a different ring, so we have
            # to hack around this...
            computed_ring = parent(computed[1])
            (y1, y2, y3, y4, y5, y6) = gens(computed_ring)
            expected = [
 385435641777613426263048919265966712483675516854427965194240000000*y2^3*y6 + 4135045376698027032593847788439386368521610555019038881218560000000*y2^2*y6^2 + 1738833261257008894611720726225458413088737749267372121784320000000*y2*y4*y6^2 + 1554656250035953161916869359591442638089287779192337145528320000000*y2*y5*y6^2 + 9330396742388670640533153190247641819519823377066585478922240000000*y2*y6^3 - 10272478123889389879949343495728028521570478134402419009781760000000*y3*y5^2*y6 + 47663541346347460286681181691322849380438581498432326142525440000000*y3*y5*y6^2 + 7452121256104298278474197596960198515047108997276507685519360000000*y3*y6^3 + 1873644445828814024271541700542599555216947863201485873479680000000*y4*y5^2*y6 - 2546752868456702449437129706716141832102220915684963411558400000000*y4*y5*y6^2 + 5957476902730373507609402061282972462141168008911509971271680000000*y4*y6^3 - 1416874811930583029400293267858643091265999830480712714158080000000*y5^4 + 3715308097339243573339884932566783885688326494604971453972480000000*y5^3*y6 - 1792308470931191723821329883138907039552450882197250774138880000000*y5^2*y6^2 - 2742810893812018193559001543012791225881982224870041106513920000000*y5*y6^3 - 13850877760864311099390049897952994900525109448940052325335040000000*y6^4
 -2394474132558509458375199684959910415842642074908308086097306719543373856612978524160000000000*y2^3*y6 - 28913630296774407553406003842515253129469688548563208649393846070267318592904772976640000000000*y2^2*y6^2 - 18241883684890371661464853499724248303159798589133366216892929306369658313036382863360000000000*y2*y4*y6^2 - 21026623954083746949492833752981019530022278009474158926779002727565701376008991539200000000000*y2*y5*y6^2 - 82518598006609305190769323882675778925403747550515120918313182591303916842366449745920000000000*y2*y6^3 + 40901390625217874731385600287702649062706936998404917836531301711830956429102148485120000000000*y3*y5^2*y6 - 359010909518282227121457881044564393024248632811326507396640255372485872528567597793280000000000*y3*y5*y6^2 - 44303295947694293657004024230359107153507763848731965300315889917035871725387660656640000000000*y3*y6^3 - 17505941981327151467023563550408125540215413706189398751406529004466495451700983234560000000000*y4*y5^3 - 22636225138445342216584534398160893390638978244073860423679285210923879022865342791680000000000*y4*y5^2*y6 + 7615911463147533379472866499625291863177816751109153932379370416477771165562044416000000000000*y4*y5*y6^2 - 43460415798197758356560809575271043763883524647676568782203851823274394046131674808320000000000*y4*y6^3 - 52985040408870919661241461321460456701786268840501524661262963934285998327124994293760000000000*y5^3*y6 - 15557768152645318705652706456695686891069875814985984608185961556479409635930008453120000000000*y5^2*y6^2 + 18842475252087809267866807013321641785841489630334823848244297273928164412206612480000000000000*y5*y6^3 + 113826702435942222202550527410150942470716078173986637653804335381114609291884201246720000000000*y6^4
 -4*y2*y6 - 8*y3*y5 - 4*y4^2 - 8*y4*y5 - 4*y5^2 + 4*y6^2
 -191734394642487456376728879164880889932766790137735503836043924493776962663597579772599730176000000000000*y2^3*y6 + 3034989467187885503938555391453256597172128462303916781976407609199479131855526508951985192960000000000000*y2^2*y6^2 + 7151526041855198647741077534182895823126707796690323254395804172231468349940801344665213206528000000000000*y2*y4*y6^2 + 14832495478536285699989219513444079325829557696427036621995306364091194845065370994813354115072000000000000*y2*y5*y6^2 + 26667505194196340565702212188528536566626836412633900419933577888455582460729341072320577404928000000000000*y2*y6^3 - 23378597204373809511426907740883951223327530309336766349093220217088668972913915065831906082816000000000000*y3*y5^3 + 3440152436718712181110268776513996654551813850716822819170942938420639520663211179355559428096000000000000*y3*y5^2*y6 + 64634779883736053194020859200730268741778720291314627917522856675592970397648550687043374546944000000000000*y3*y5*y6^2 + 17566137850892116937858807069618038472997415495898809329916988043406043304040089763866214400000000000000*y3*y6^3 - 19630334709750449599226595488368854173959341790821878414275533308386687452697840712018133254144000000000000*y4*y5^2*y6 + 20425905093017353575342220860551855136401394738631135488827473696872547153937816377423634104320000000000000*y4*y5*y6^2 + 7220385302230695746137484057895798533940857665434246586969078765361620039692638496539568766976000000000000*y4*y6^3 + 7565384249622216922797031028743096809550526905773699202208648410534114730183985859501901217792000000000000*y5^3*y6 - 32146032267132573996281616937401010405585270357494821073748088119433059246393364267875172352000000000000*y5^2*y6^2 + 1921032835373561908324239141133428687406997358631493788319721812426884895729824216576409206784000000000000*y5*y6^3 - 29510760266741738613264038700816912273866198084800081698073941573161284629921270001499962867712000000000000*y6^4
 -y2*y5 - 2*y3*y4 + 2*y3*y5 - 2*y3*y6 + 2*y4*y5 + 2*y5^2 + 2*y5*y6
 8*y2*y4 + 8*y2*y5 + 16*y2*y6 + 8*y3^2 + 32*y3*y5 + 16*y3*y6 - 16*y5*y6 - 16*y6^2
 -163840*y2^2*y6 + 98304*y2*y4*y6 - 606208*y2*y5^2 + 32768*y2*y5*y6 - 294912*y2*y6^2 + 1605632*y3*y5^2 - 1933312*y3*y5*y6 - 393216*y3*y6^2 + 2031616*y4*y5^2 - 393216*y4*y5*y6 - 327680*y4*y6^2 + 1212416*y5^3 + 1835008*y5^2*y6 - 131072*y5*y6^2 + 458752*y6^3
 36700160*y2^2*y6 - 96993280*y2*y4*y5 - 99614720*y2*y4*y6 - 259522560*y2*y5*y6 - 89128960*y2*y6^2 - 592445440*y3*y5^2 - 110100480*y3*y5*y6 + 10485760*y3*y6^2 - 377487360*y4*y5^2 + 10485760*y4*y5*y6 + 73400320*y4*y6^2 - 193986560*y5^3 - 178257920*y5^2*y6 + 262144000*y5*y6^2 + 52428800*y6^3
 -8*y2*y3 - 16*y2*y4 - 16*y2*y5 - 32*y2*y6 - 48*y3*y5 - 16*y3*y6 - 16*y4*y5 + 16*y5*y6 + 32*y6^2
 -193986560*y2^2*y5 - 251658240*y2^2*y6 + 461373440*y2*y4*y6 - 492830720*y2*y5*y6 + 167772160*y2*y6^2 - 2034237440*y3*y5^2 - 1572864000*y3*y5*y6 - 293601280*y3*y6^2 - 1845493760*y4*y5^2 + 482344960*y4*y5*y6 - 503316480*y4*y6^2 - 775946240*y5^3 - 440401920*y5^2*y6 + 1195376640*y5*y6^2 + 83886080*y6^3
 620756992*y2^2*y4 - 268435456*y2^2*y6 + 2147483648*y2*y4*y6 - 3422552064*y2*y5*y6 - 1476395008*y2*y6^2 - 6308233216*y3*y5^2 - 7885291520*y3*y5*y6 + 1342177280*y3*y6^2 - 12314476544*y4*y5^2 + 1342177280*y4*y5*y6 - 3019898880*y4*y6^2 - 4966055936*y5^3 - 6677331968*y5^2*y6 + 3758096384*y5*y6^2 + 1744830464*y6^3
 95482741799688119048687979168406002446421435212481615421719401049985521678742341990798980994914340686281137126568238009020724492690660513291377812412758162712269135609266409319038009433797947014909681546461043437921227143043345973631850999188719779583820406362750006774714179252708018104145308183108445591981349878292807680000000000000000000000000000000000000*y2^4*y6 + 746846522250271123001066525966945476460958320740386502610529704904460009016240142316132702333031686185298802628856651760855736336350217831930195927782304950767220497738868620014215845265472682586734470478087700062806151145266760903011433934438318320431133481516811632084121054566288598654469904290174066369306443932657254400000000000000000000000000000000000000*y2^3*y6^2 - 5562106284110011049661372556180961560688922688904866808702078988961446498149157287694359947809782052283326899998660138552153431920372201787277050804141473935350198084459562282216429563450090592694356726287427999067931419053485285064264993199094860681539254400547747699079264245729862161930482579709131221073655208227823943680000000000000000000000000000000000000*y2^2*y6^3 + 19431157297148117088459592983950778635614946764166487977807864775003296037308166895670038830155272083778620539930805443056654345753852059234379113085517022289588086720855599232190879629081536575896045032286169456808393995767539156847341886292805021446738575800617393492232165504733505346829714997570896390149140112618312171520000000000000000000000000000000000000*y2*y4*y6^3 + 11811096568572344231032493102530145898904485632191337644112607978115793523190655626110137872974769331163115875624685845721131589857875206465802647916760532562983979836528629546396778720856624582207584791810153779050595006854079558314561230574938117823266976654773850938332545507467138158672244712044241715752885753824443105280000000000000000000000000000000000000*y2*y5*y6^3 + 17022741465886953341763287712224673682594127390817852603446320282695288639513424526155861375817892259773390568173958193234938112951195990514132590166918333464352092439903791413694803943569803583912398729752986446941066109205511855067610645038782911988651931316462996676998900505614451460969473229547007190565631694083110993920000000000000000000000000000000000000*y2*y6^4 + 7222742209842936341399181739309865372173662624912859922414009727790235408287771591871493659275284879392133545241118008306018339250348299282542170839206826557276021945850054429488016064425086025737352025077625790538761147493612900657064303421623714713699656488484058263298114152854982992182235004977261489365022329941010677760000000000000000000000000000000000000*y3*y5^2*y6^2 + 30928829356974087470469535612111568738948324043613373275249780875519099517108694040381741301036057402837548482561708083535242480723097976449225050514159552365305774130997758088249692799777558542436598268086139500729581082661839466172064741928314804601721738967523112053285928888495663781759789038144631749938139231494487408640000000000000000000000000000000000000*y3*y5*y6^3 + 4529094205954541156594355273090289800208913529045483398848219762796695443377332580336067773646738360503583657866270867270735339261763932343883309863844880901904988219245733894796097150046850787958698833081079091999182225025432354466234006156590494643851719586485577822119529362664859129286315919782345451117948859194036715520000000000000000000000000000000000000*y3*y6^4 - 12119570773999752214946462499152565423131754089054341312482239183028747822833492279034871369059504577774022321446927294377764541256362068036472403758697047238915641624502429480892402963583155217212030583386984034931367378667227612485758998312460944399378421571205553745573642113684995089960353795957072769666380009882192445440000000000000000000000000000000000000*y4*y5^2*y6^2 + 12282813124142392371953144253678201863203051849819748046672114722234163038671723218685920193076957781437688475804017892425841689391586332480207550479501541534544122340714813988333413358991706259536974713257638709470141013897934213102311056325906116755977270161112718767036658332083541713703449069366233280874797448031906037760000000000000000000000000000000000000*y4*y5*y6^3 - 12358878480532252789673752976437791896965266505027677708728876571650145313318515801598350755790666638344887953467140095362736649107363253114228431552943000043086568544637278367670861877743887082402191102863706721623378022115097372443115656032403158779815415873862864960322972724265383300246844106933619690235783184189635952640000000000000000000000000000000000000*y4*y6^4 - 4468496753848290021734762207754460057776146432562775983772743145718755289772802580306682586811203907079739087944951602303728851320982771244208333452964708945880605285493875529366022339740842704671069266834880791817044117973684928500775999388221388050047815381006362285356765659906549050758800277540101000047754382294216867840000000000000000000000000000000000000*y5^3*y6^2 - 7799370758882407147038387696412991601856634009865328748933038832542026790385357831022113243079569775407798671807246308499259561446451814361254602651282810257399310466900249011763383176284691453248081295020494195956346788824159277288213154150714359926779486362691327379792202135902827153900734155304176934114901900948228014080000000000000000000000000000000000000*y5^2*y6^3 - 8755470907036947097627096884027930603909829807684882577832273659468954675202882077555080905385293951833665312383409134413148724227200834958636360129370675852247745990028286716673228992273112038425500885282897249493106808430262844214135785472482770962547224027149005136995409741186741513755738723559510083634338020043008245760000000000000000000000000000000000000*y5*y6^4 - 12302964445826901534151669661179063600812584457865853912776490399688287672059249722768433111336056234361643607930722944452661141859864667072077113102971922642481383988792364160811628234818983620819686155490107191373862068440336676879988936773315089407127630803794810616778471493703585915797605862311158481453264279666237112320000000000000000000000000000000000000*y6^5
 -y1 + y2 + 2*y3 + 2*y4 + 2*y5 + 2*y6]
            @test computed == expected
        end
    end
end
