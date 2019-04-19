# vim: sw=4 ts=4 sts=4 tw=0 et:
from kmers import hash        # avoiding "*" imports
import unittest
import deques
import sequtils
import sets

test "bin_to_dna":
    check kmers.bin_to_dna(0, 1, false) == "A"
    check kmers.bin_to_dna(1, 1, false) == "C"
    check kmers.bin_to_dna(2, 1, false) == "G"
    check kmers.bin_to_dna(3, 1, false) == "T"

    check kmers.bin_to_dna(0b00011011, 4, false) == "ACGT"
    check kmers.bin_to_dna(0b00011011, 4, true) == "TGCA"

test "dna_to_kmers":
    check kmers.dna_to_kmers("AAAA", 2).seeds.len() == 6

test "sorted_kmers":
    let
        sq = "ATCGGCTACTATT"
        expected = [
            "AGCCGATGATAA",
            "TAGCCGATGATA",
            "ATCGGCTACTAT",
            "TCGGCTACTATT",
        ]
        k = 12
        kms = kmers.dna_to_kmers(sq, k)
    discard kmers.make_searchable(kms) # sort
    let got = sequtils.mapIt(kms.seeds, kmers.bin_to_dna(it.kmer, k.uint8,
            it.strand))
    check got == expected

test "search":
    let
        sq = "ATCGGCTACTATT"
        k = 12
        kms = kmers.dna_to_kmers(sq, k)
        qms = kmers.dna_to_kmers(sq, k)
    check kmers.make_searchable(kms) == 0
    let hits = kmers.search(kms, qms)
    check hits.len() == 4
    check sets.toHashSet(seqUtils.toSeq(hits)).len() == 4 # 4 unique items
    #check sets.len(sets.toHashSet(seqUtils.toSeq(deques.items(hits)))) == 4  # same as above

suite "difference":
    let
        sq = "ATCGGCTACTATT"
        k = 12

    test "exc":
        let qms = kmers.dna_to_kmers(sq, k)
        let kms = kmers.dna_to_kmers(sq, k)
        expect kmers.PbError:
            kmers.difference(kms, qms)

    test "difference_of_self_is_nothing":
        let kms = kmers.dna_to_kmers(sq, k)
        let qms = deepCopy(kms)
        check qms[] == kms[]
        check kmers.nkmers(qms) == 4
        check kmers.nkmers(kms) == 4
        discard kmers.make_searchable(qms)
        check qms.searchable
        check not kms.searchable

        kmers.difference(kms, qms)

        check kmers.nkmers(kms) == 0
        check kmers.nkmers(qms) == 4
        check qms.searchable
        check not kms.searchable

        let
            expected: array[0, string] = []
            got = kmers.get_dnas(kms)
        check got == expected

    test "difference_of_nothing_is_self":
        let kms = kmers.dna_to_kmers(sq, k)
        let qms = kmers.dna_to_kmers("", k)
        let orig = deepCopy(kms)
        check kmers.nkmers(qms) == 0
        check kmers.nkmers(kms) == 4
        discard kmers.make_searchable(qms)
        check qms.searchable

        kmers.difference(kms, qms)

        check kmers.nkmers(kms) == 4
        let got = kmers.get_dnas(kms)
        let expected = kmers.get_dnas(orig)
        check got == expected
