module CharMap = Map.Make(Char);;

let frequencies = CharMap.empty
  |> CharMap.add 'A' 8.17
  |> CharMap.add 'B' 1.49
  |> CharMap.add 'C' 2.78
  |> CharMap.add 'D' 4.25
  |> CharMap.add 'E' 12.70
  |> CharMap.add 'F' 2.23
  |> CharMap.add 'G' 2.02
  |> CharMap.add 'H' 6.09
  |> CharMap.add 'I' 7.00
  |> CharMap.add 'J' 0.15
  |> CharMap.add 'K' 0.77
  |> CharMap.add 'L' 4.03
  |> CharMap.add 'M' 2.41
  |> CharMap.add 'N' 6.75
  |> CharMap.add 'O' 7.51
  |> CharMap.add 'P' 1.93
  |> CharMap.add 'Q' 0.10
  |> CharMap.add 'R' 5.99
  |> CharMap.add 'S' 6.33
  |> CharMap.add 'T' 9.06
  |> CharMap.add 'U' 2.76
  |> CharMap.add 'V' 0.98
  |> CharMap.add 'W' 2.36
  |> CharMap.add 'X' 0.15
  |> CharMap.add 'Y' 1.97
  |> CharMap.add 'Z' 0.07
;;

let alphabet =
	CharMap.fold (fun key _ acc -> key :: acc) frequencies []

(* GPT *)
(* Function to print an int list *)
let rec print_list_int = function
	| [] -> ()  (* Do nothing for an empty list *)
	| h::t ->   (* Print the head and recursively print the tail *)
		Printf.printf "%d " h; flush stdout;
		print_list_int t
(* Function to print a float list *)
let rec print_list_float = function
	| [] -> ()  (* Do nothing for an empty list *)
	| h::t ->   (* Print the head and recursively print the tail *)
		Printf.printf "%f " h; flush stdout;
		print_list_float t

(* Fast integer expoentiation *)
let rec pow base exponent =
	match exponent with
		| 0 -> 1
		| _ -> 
			let sqroot = pow base (exponent / 2) in
			match exponent mod 2 with
				| 0 -> sqroot * sqroot
				| 1 -> sqroot * sqroot * base
				| _ -> failwith "aaughghh matematika je propadla"

(* GPT *)
(* Read text from file *)
let read_file filename =
	let ic = open_in filename in
	let try_read () =
			try Some (input_line ic) with End_of_file -> None in
	let rec loop acc = match try_read () with
			| Some s -> loop (acc ^ s ^ "\n")
			| None -> close_in ic; acc in
	loop ""

(* Calculate x! *)
let rec factorial x =
	match x with
		| 1 -> 1
		| _ -> x * factorial (x-1)

(* Generate a unique permutation from an int *)
let permutation n idx =
	let rec helper n nums_left permutation =
		match nums_left with
			| [] -> permutation
			| _ ->
				let picki = idx mod n in
				let new_perm = (List.nth nums_left picki)::permutation in
				helper (n-1) (List.filteri (fun idx _ -> idx <> picki) nums_left) new_perm
	in
	helper n (List.init n Fun.id) []

(* Extract first N characters from string *)
let str_head str n =
	let length = String.length str in
	if n < length then String.sub str 0 n
	else str

(* Dot product of two lists *)
let rec dot v1 v2 = match (v1, v2) with
	| ([], []) -> 0.0
	| (h1::t1, h2::t2) -> h1 *. h2 +. dot t1 t2
	| _ -> failwith "no"

(* Take the first n elements from the list, return head and remainder *)
let list_head list n =
	let rec helper taken to_take list =
		match to_take with
			| 0 -> List.rev taken, list
			| _ ->
				match list with
					| el::tail -> helper (el::taken) (to_take-1) tail
					(* | _ -> failwith "List too short to take n" *)
					(* | _ -> helper "?"::taken (to_take-1) tail *)
					| _ -> helper taken 0 []
	in
	helper [] n list

(* Multiply matrix and list of floats representing text *)
let block_dot key blocks =
	let block_size = List.length (List.hd key) in
	let rec foreach_block mat blocks =
		let rec foreach_vector mat block =
			match mat with
				| [] -> []
				| vec::mat_tail ->
					dot vec block::(foreach_vector mat_tail block)
		in
		let (block, blocks_tail) = list_head blocks block_size in
		match block with
			| [] -> []
			| _ ->
				foreach_vector mat block @ (foreach_block mat blocks_tail)
	in
	foreach_block key blocks

(* Convert a string to an array of floats *)
let str2vec text =
	List.map (fun ch -> float_of_int (Char.code ch - Char.code 'a')) text

(* Convert an array of floats to string *)
let vec2str vec =
	let modded = List.map (fun x -> x mod (List.length alphabet) + (Char.code 'a')) vec in
	String.concat "" (List.map (fun x -> String.make 1 (Char.chr x)) modded)

(* Perform a text pass of hill cipher with a vector key *)
let hill_part vec text =
	vec2str (List.map int_of_float (block_dot [vec] (str2vec text)))

(* Perform a hill cipher with a full matrix key *)
let rec hill text key =
	vec2str (List.map int_of_float (block_dot key (str2vec text)))

(* Create a histogram of the occurrences of each letter in text *)
let histogram text =
	(* Count the number of occurrences of a letter in text *)
	let rec count_occurrences text ch =
		match text with
			| "" -> 0
			| _ -> let first = String.get text 0 in
				let new_strlen = String.length text - 1 in
				let tail = String.sub text 1 new_strlen in
				match first with
					| c when c = ch -> 1 + count_occurrences tail ch
					| _ -> count_occurrences tail ch
	in
	let rec helper hist remaining_chars =
		match remaining_chars with
			| first::rest -> helper (CharMap.add first (count_occurrences text first) hist) rest
			| [] -> hist
	in
	helper CharMap.empty alphabet

(* Chi2 *)
let chi2 text =
	let observed = histogram (String.uppercase_ascii text) in
	let exp_multi = (float_of_int (String.length text)) /. 100.0 in
	CharMap.fold (fun key expected_value acc ->
		let observed_value = float_of_int (CharMap.find key observed) in
		acc +. (observed_value -. expected_value *. exp_multi) ** 2.0 /. (expected_value *. exp_multi)
	) frequencies 0.

(* Break hill cipher of sample string using frequency analysis *)
let break_hill sample =
	(* Find keys with lowest chi2 *)
	let find_best_keys text keylen =
		(* Convert an int to a list of numbers modulo 26 *)
		let int2vec i len =
			let rec helper i len vec =
				match len with
					| 0 -> vec
					| _ ->
						let alphabet_length = List.length alphabet in
						let new_vec = (float_of_int (i mod alphabet_length))::vec in
						helper (i / alphabet_length) (len - 1) new_vec
			in
			helper i len []
		in
		let rec helper text keylen keyi best_keys best_scores =
			match keyi with
				| 0 -> best_keys
				| _ ->
					let score = chi2 (hill_part (int2vec keyi keylen) text) in
					let enumerated_scores = List.mapi (fun idx el -> (el, idx)) (score::best_scores) in
					let enumerated_order = (list_head (List.sort (fun (x, _) (y, _) -> int_of_float (x -. y)) enumerated_scores) keylen) in
					let order = List.map snd (fst enumerated_order) in
					let new_best_keys = List.map (fun idx -> List.nth ((int2vec keyi keylen)::best_keys) idx) order in
					let new_best_scores = List.map (fun idx -> List.nth (score::best_scores) idx) order in
					if keyi mod 100 = 0 then Printf.printf "%d keys left ...\n" keyi; flush stdout;
					helper text keylen (keyi - 1) new_best_keys new_best_scores
		in
		let max_key = pow (List.length alphabet) keylen - 1 in
		Printf.printf "Finding best %d of %d keys\n" keylen (max_key + 1); flush stdout;
		helper text keylen max_key [] []
	in
	(* Strinfigy a matrix *)
	let fmatrix2str mat =
		let vec_repr vec =
			let rec helper vec out =
				match vec with
					| [] -> "\n"
					| head::tail -> out ^ (string_of_float head) ^ helper tail out
			in
			helper vec ""
		in
		let rec helper mat out =
			match mat with
				| [] -> out
				| vec::tail -> helper tail (out ^ (vec_repr vec))
		in
		helper mat ""
	in
	(* Break hill cipher for a given keylength *)
	let rec break_hill_keylen text keylens =
		Printf.printf "Keylens that divide cipher_len: "; flush stdout;
		print_list_int keylens;
		Printf.printf "\n"; flush stdout;
		match keylens with
			| keylen::remaining_keylens ->
				let keys = find_best_keys text keylen in
				let rec try_permutations idx =
					match idx with
						| -1 -> ()
						| _ ->
							let full_key = List.map (fun i -> List.nth keys i) (permutation keylen idx) in
							Printf.printf "%s" (fmatrix2str full_key ^ (hill text full_key)); flush stdout;
							Printf.printf "\n===\n"; flush stdout;
							Printf.printf "Press enter to continue ...\n"; flush stdout;
							ignore (input_line stdin);
							try_permutations (idx - 1);
				in
				Printf.printf "Trying %d different keys for keylen = %d\n" (factorial keylen) keylen; flush stdout;
				try_permutations (factorial keylen - 1);
				Printf.printf "Keys of length %d exhausted\n" keylen; flush stdout;
				break_hill_keylen text remaining_keylens;
			| _ -> Printf.printf "opa\n"
	in
	(* Return a list of prime factors of n *)
	let rec factorize n =
		let rec helper n factor =
			match factor with
				| 0 -> [n]
				| _ -> match n mod factor with
					| 0 -> [factor] @ helper n (factor - 1)
					| _ -> helper n (factor - 1) in
		List.sort (fun x y -> x - y) (helper n (n-1))
	in
	break_hill_keylen sample (factorize (List.length sample))

(* Main *)
let () =
	let cipher = read_file "cipher.txt" in
	let cipher_arr = List.filter (fun ch -> ch <> '\n') (List.init (String.length cipher) (String.get cipher)) in
	let cipher_len = List.length cipher_arr in
	Printf.printf "cipher_len = %d\n" cipher_len; flush stdout;
	break_hill cipher_arr;
