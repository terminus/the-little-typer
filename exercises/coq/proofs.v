Require Import Arith Bool List.

Theorem same_cons : forall A (e:A) (l1: list A) (l2: list A), l1 = l2 -> (e::l1) = (e::l2).
Proof.
  intros.
  rewrite H.
  reflexivity.
Qed.

Theorem same_lists :
  forall A (l1: list A) (l2: list A) (e1:A) (e2:A), e1 = e2 -> l1 = l2 -> (e1::l1) = (e2::l2).
  intros.
  rewrite H.
  eapply same_cons.
  exact H0.
Qed.

Theorem same_lists2 :
  forall A (l1: list A) (l2: list A) (e1:A) (e2:A), e1 = e2 -> l1 = l2 -> (e1::l1) = (e2::l2).
  intros.
  rewrite H.
  rewrite H0.
  reflexivity.
Qed.

Theorem list_length_append_dist :
  forall A (l1:list A) (l2:list A), length (app l1 l2) = (length l1) + (length l2).
Proof.
  intros.
  induction l1.
  - simpl.
    reflexivity.
  - simpl.
    rewrite IHl1.
    reflexivity.
Qed.

Definition leq a b := exists k, k + a = b.

Lemma one_leq_two : leq 1 2.
Proof.
  exists 1.
  ring.
Qed.

Search (_ -> False).

Search (?x + ?y = ?y + ?x).
Search (?x + 1 = S (?x)).
Search (?x + (?y + _) = (?x + ?y) + _).
Search (?x + (?y + _) = ?x + ?y + _).
(* Nat.add_1_r: forall n : nat, n + 1 = S n *)

Search (2 = _).
Print Nat.two_succ.

Lemma one_plus_one_two : 2 = 1 + 1.
Proof.
  simpl.
  reflexivity.
Defined.

Print one_plus_one_two.
Check eq_add_S.
(*eq_add_S
     : forall n m : nat, S n = S m -> n = m
*)
Locate "~".

Search (2 = 1 + 1).
Search (S O = 1 ).

Lemma not_two_leq_one : ~leq 2 1.
Proof.
  unfold leq.
  unfold not.
  intro H.
  destruct H as [k H1].
  rewrite BinInt.ZL0 in H1.
  rewrite Nat.add_assoc in H1.
  rewrite (Nat.add_1_r (k + 1)) in H1.
  apply  (eq_add_S (k+1) O) in H1.
  rewrite Nat.add_1_r in H1.
  discriminate.
Defined.

Lemma leq_trans : forall (a b c: nat), leq a b -> leq b c -> leq a c.
Proof.
  intros ? ? ? Hab Hbc.
  unfold leq in Hab.
  unfold leq in Hbc.
  destruct Hab as [kab Hab].
  destruct Hbc as [kbc Hbc].
  induction Hab.
  rewrite Nat.add_assoc in Hbc.
  exists (kbc + kab).
  apply Hbc.
Defined.

Lemma length_filter_list : forall A (l : list A) (p : A -> bool), leq (length (filter p l)) (length l).
Proof.
  intros.
  unfold leq.
  induction l.
  - unfold filter.
    exists 0.
    reflexivity.
  - destruct IHl as [kl IHl].
    simpl.
    induction (p a).
    + cbn.
      rewrite <- IHl.
      exists kl.
      ring.
    + rewrite <- IHl.
      exists (S kl).
      ring.
Defined.

Lemma inj_plus : forall k a: nat, k + a = a -> k = 0.
Proof.
  intros.
  induction a.
  - rewrite Nat.add_0_r in H.
    apply H.
(* Nat.add_succ_r: forall n m : nat, n + S m = S (n + m) *)
  - Search (_ + S _ = S _).
    rewrite Nat.add_succ_r in H.
    Search (S ?x = S ?y -> ?x = ?y).
    (* eq_add_S: forall n m : nat, S n = S m -> n = m *)
    apply eq_add_S in H.
    apply IHa.
    exact H.
Defined.

Lemma sum_to_zero : forall n m: nat, n + m = 0 -> m = 0.
Proof.
  intros.
  induction n.
  - exact H.
  - rewrite Nat.add_succ_l in H.
    Search (S _ = 0).
    (* Nat.neq_succ_0: forall n : nat, S n <> 0 *)
    eapply Nat.neq_succ_0 in H.
    induction H.
Defined.

Lemma leq_antisymmetry : forall a b: nat, leq a b -> leq b a -> a = b.
Proof.
  intros ? ? leqab leqba.
  unfold leq in leqab.
  destruct leqab as [kab leqab].
  destruct leqba as [kba leqba].
  induction leqab.
  rewrite Nat.add_assoc in leqba.
  eapply inj_plus in leqba.
  eapply sum_to_zero in leqba.
  rewrite leqba.
  reflexivity.
Defined.

Check nat_rec.

Definition double_num : nat -> nat :=
  nat_rec (fun _ => nat)
          0
          (fun _ prev => 2 + prev).

Print Nat.Even.

Definition Even : nat -> Prop := fun n => exists k, n = 2 * k.
Definition Odd : nat -> Prop := fun n => exists k, n = 2 * k + 1.

Lemma zero_is_even : Even 0.
Proof.
  unfold Even.
  exists 0.
  reflexivity.
Defined.

Lemma one_is_odd : Odd 1.
  unfold Odd.
  exists 0.
  reflexivity.
Defined.

Search (Nat.Even).

Lemma sum_of_two_evens_is_even : forall n m : nat, Even n -> Even m -> Even (n + m).
Proof.
  intros ? ? en em.
  unfold Even in en.
  unfold Even in em.
  induction en as [k_en en].
  induction em as [k_em em].
  unfold Even.
  rewrite en.
  rewrite em.
  Search (?x * _ + ?x * _).
  (* Nat.mul_add_distr_l: forall n m p : nat, n * (m + p) = n * m + n * p *)
  exists (k_en + k_em).
  rewrite Nat.mul_add_distr_l.
  reflexivity.
Defined.

Lemma two_is_even : Even 2.
Proof.
  exists 1.
  reflexivity.
Defined.

Lemma nOrSuccIsEven : forall n : nat, Even n \/ Even (S n).
Proof.
  intros.
  induction n.
  left; exact zero_is_even.
  destruct IHn.
  - right; exact (sum_of_two_evens_is_even 2 n two_is_even H).
  - left; exact H.
Defined.

Lemma succ_of_even_is_odd : forall n : nat, Even n -> Odd (S n).
Proof.
  intros.
  unfold Even in H.
  destruct H as [k H].
  unfold Odd.
  exists k.
  rewrite <- H.
  Search (_ + 1).
  (* Nat.add_1_r: forall n : nat, n + 1 = S n *)
  rewrite <- Nat.add_1_r.
  reflexivity.
Defined.

Lemma succ_of_odd_is_even : forall n : nat, Odd n -> Even (S n).
Proof.
  intros.
  unfold Odd in H.
  destruct H as [k H].
  unfold Even.
  exists (k + 1).
  rewrite H.
  ring.
Defined.

Lemma even_or_odd : forall n : nat, Even n \/ Odd n.
  intros.
  induction n.
  - left; exact zero_is_even.
  - destruct IHn.
    + right; apply succ_of_even_is_odd.
      exact H.
    + left; apply succ_of_odd_is_even.
      exact H.
Defined.
