# Instructions: creating a multilingual `.all` file from a `.cycl` file

**Prepared by:** Academia Co-scientist (AI research assistant).  
**How to invoke the assistant:** open Academia Co-scientist on Academia.edu, attach the source `.cycl`, the required grammars, and these instructions; request creation of an `.all` file. To continue earlier work, open the corresponding chat.

These instructions describe the conventions adopted for `MathMt.all`. They specify the working container format `multilingual-knowledge-units-1`, not a generally established standard for the `.all` extension. The result consists of aligned records in eight languages, preserving context and source uncertainty. Automatic translation of arbitrary CycL without semantic analysis is not assumed.

## 1. Input and output

Required inputs:

1. A source `NameMt.cycl`, presumed to contain a microtheory.
2. The name of the selected microtheory and the grounds for attributing the records to it.
3. For the `fol` language, the exact versions of `fol_lexer_min.g4` and `fol_parser_min.g4`. The label “FOL” alone is insufficient: these particular files define the syntax.
4. Export information: the meaning of administrative comments, the origin of `ist` wrappers, available line numbers from the original dump, and reconstruction hypotheses.

Create `NameMt.all` without modifying the source `.cycl`. File names, directory names, and technical identifiers must be English/ASCII. Save files containing Russian text as **UTF-8 with BOM and CRLF**. Do not create additional translations as separate files unless requested.

| Label | Content |
|---|---|
| `cycl` | The selected source CycL formula; provenance is recorded in comments |
| `rus` | A precise Russian reading |
| `eng` | A corresponding English reading |
| `fol` | A first-order representation following the supplied grammars |
| `isb` | Isabelle/HOL |
| `len` | Lean 4 |
| `ofs` | OWL 2 Functional-Style Syntax; the target semantics is OWL 2 DL Direct Semantics |
| `col` | Common Logic in CLIF notation |

All eight parts are mandatory for every included unit. A missing translation must be stated explicitly, not handled by removing the language part.

## 2. Establish the microtheory boundaries

1. Read the header, comments, and formulas; do not infer membership solely from the file name.
2. Distinguish the selected Mt's own assertions, records about it, its ancestors, and inherited assertions. The presence of `genlMt` does not turn ancestor content into the selected Mt's own records.
3. If contexts are mixed, select the required context explicitly; do not combine different Mts under one header.
4. If membership is only presumed, write `microtheory-status: assumed` in the header and explain the grounds in `conventions`. Use `confirmed` when membership is confirmed. Do not present an assumption as an established fact.
5. Under the selected approach, Mt membership is container metadata. An outer `(#$ist #$NameMt FORMULA)` may be removed only when it is established that this wrapper is export packaging for the selected formula. Record its removal. **Do not remove semantically significant or nested `ist` occurrences**: doing so may change the meaning.

By default, do not translate ancestors or duplicate their content across units. If inherited content is separately requested, preserve its original Mts and distinguish it from the selected Mt's own content.

## 3. Parse the source and select knowledge units

**A knowledge unit is one selected CycL formula**, not one physical line or every automatically proposed repair.

- Parse expressions with proper handling of parentheses, strings, escaping, and comments. A formula may span multiple lines; counting parentheses alone does not replace parsing.
- Preserve the selected formula's text and a reference to its source location. If an export wrapper is removed, also retain enough information to reconstruct the original record.
- Distinguish line numbers in the input `.cycl` from line numbers in the original dump: a `source_line` comment may refer to the latter. State explicitly which reference system is used.
- Use stable identifiers, such as `NameMt_L63625`. If original line numbers are unavailable, sequential numbering such as `NameMt_U0001` is acceptable; describe the rule in `conventions`.
- Do not silently merge repeated occurrences: either retain them separately or list all source locations and explain the deduplication.

### Malformed records and reconstructions

Distinguish at least the following:

| Status | Meaning |
|---|---|
| `original` | The formula occurs in the source as a well-formed record; this is not a claim that it is true |
| `reconstructed_candidate` | An explicitly identified reconstruction hypothesis has been selected |
| `unresolved` | The source expression could not be reconstructed with sufficient certainty |

Do not turn `CANDIDATE ... (NOT ASSERTED)` in a comment into a confirmed assertion. For a selected hypothesis, identify the malformed fragment or provide a precise reference to it, and state the reconstruction method and status. If several alternatives were proposed, explain the selection of one; do not count the others as additional source knowledge. A syntactic repair does not establish the semantic correctness of a reconstruction.

Account for unresolved cases in the audit: by default, do not create a fictitious logical formula for them. If they must be retained as units, keep the source fragment only in comments within `cycl`, and state in the target parts that no translation was performed because the source formula has not been established. This is **not** a proof of nonexpressibility in the target language.

## 4. The `.all` container contract

Order of shared components:

1. English-language file attributes.
2. `[conventions]`: one `rus:` section and one `eng:` section with matching content.
3. Shared blocks `fol-signature`, `isb-signature`, `len-signature`, `ofs-signature`, and `col-signature`.
4. Units `[unit ID] … [/unit ID]` in a stable order.
5. Closing blocks `isb-trailer`, `len-trailer`, `ofs-trailer`, and `col-trailer`, as required to assemble the corresponding files.
6. `[provenance]` with actual totals and validation information.

Shared block names identify container components, not language labels within a unit. If a particular target format requires no closing material, do not add artificial closing code.

Within each unit, **only the eight language labels** are permitted, each exactly once and in this order:

```text
cycl:
rus:
eng:
fol:
isb:
len:
ofs:
col:
```

A part continues until the next language label outside comments or until `[/unit ID]`. Labels such as `source-line:`, `status:`, `variable-map:`, `note:`, `isb-end:`, and `len-end:` are forbidden within a unit. Put their information in the corresponding language's native comments. The IDs in `[unit ID]` and `[/unit ID]` must match.

### Initial attributes

The beginning of the file must identify, in English, who performed the work and how to contact or invoke them. For example:

```text
format: multilingual-knowledge-units-1
microtheory: #$NameMt
microtheory-status: assumed
encoding: UTF-8 with BOM; CRLF
source: NameMt.cycl
work-performed-by: Academia Co-scientist (AI research assistant).
how-to-invoke: Open Academia Co-scientist on Academia.edu and send a message in its chat; attach the source .cycl and this instruction.
fol-grammar: fol_lexer_min.g4 + fol_parser_min.g4
languages: cycl, rus, eng, fol, isb, len, ofs, col
```

Substitute actual values. It is advisable to include in `provenance` the SHA-256 hashes of the input bytes and grammars, the number of units, source statuses, translation outcomes by language, and checks actually performed. Metadata must not attribute actions to the assistant that it did not perform.

## 5. Bilingual comments

Format **every substantive comment** as two corresponding blocks: `eng` and `rus`. These labels are **inside the comment**; they do not create additional language parts within the unit. This rule also applies to shared signatures, provenance, statuses, variable mappings, and nonexpressibility notices.

| Part | Native comment | Two-block format |
|---|---|---|
| `cycl` | `;;` to the end of the line | `;; eng:` and English text; then `;; rus:` and Russian text |
| `fol` | `--` to the end of the line | `-- eng:` …; then `-- rus:` … |
| `isb` | `(* … *)` | Two separate comments: `eng:` inside the first, `rus:` inside the second |
| `len` | `/- … -/` | Two separate comments with internal labels |
| `ofs` | `#` to the end of the line | `# eng:` …; then `# rus:` … |
| `col` | Lexical `/* … */` comments in the selected CLIF implementation | Two separate comments with internal labels |

Indent internal labels in block comments. Check that the content is valid for the selected tool: do not insert an unescaped closing delimiter inside a comment. For CLIF, verify that the target parser supports the chosen lexical comment form; if its dialect differs, use a supported form without changing the logical formula.

Example of nonexpressibility in OWL:

```text
ofs:
# eng:
# Not expressible in ofs under the adopted direct OWL 2 DL representation:
# the formula requires a general ternary relation. No reification is introduced.

# rus:
# не выразимо на ofs при принятом прямом представлении в OWL 2 DL:
# формула требует общего тернарного отношения. Реификация не вводится.
```

In `rus` and `eng`, write natural-language explanations directly, without additional administrative labels. Shared `conventions` must have one label per language for the entire corresponding text, rather than repeating labels for every paragraph.

## 6. Agree on the semantics before translating

For each unit, establish:

1. Bound and free variables, their scopes, and quantifier kinds. Universally close free `?varN` variables **only when the source convention has been established**; do not turn explicitly bound variables into free ones or change their scope. For the MathMt considered here, implicit universal closure of free `?varN` variables was adopted.
2. The complete connective structure, argument order, equality, negation, and definedness conditions. Do not replace disjunction with conjunction or `evaluate` with equality.
3. The signature: domains, names, arities, and cross-language correspondences. Rename bound variables without capture; in the adopted style, `?varN` corresponds to `vN`.
4. The semantic significance of `ist`, quotation, contexts, modal, nonmonotonic, and other special CycL constructs. Do not treat them as ordinary predicates while claiming preservation of meaning without justification.
5. The outcome's status: direct translation, translation relative to a signature correspondence, interpretation-dependent formalization, or no translation.

### Domain and numbers

For MathMt, a common domain is used: `Object` / `cyc_value` / `S.Carrier` / the CL object domain. Classes such as `Integer` and `RealNumber` remain predicates; they do not become the built-in types `int`, `real`, `Int`, or `Real`. For other source material, construct the required signature rather than automatically copying mathematical names.

The supplied FOL lexer has no numeric literals: 0 and 1 are represented by the declared constants `Zero` and `One`. This adds no arithmetic, distinctness of constants, domain closure, or unique-name assumption. Explicitly align domain nonemptiness across systems; in parameterized Lean, do not allow an empty carrier if it must correspond to a nonempty FOL domain.

### Partial operations

For known binary operations, an explicitly declared correspondence is permitted:

```text
PlusValue(x y z)  <->  (#$evaluate z (#$PlusFn x y))
```

The same applies to `TimesValue`, `DifferenceValue`, and `QuotientValue` if they actually occur. Argument order in a graph is: operation arguments first, result last. This is **a change of signature to an evaluation graph**, not a literal identity of notation.

Do not postulate totality or single-valuedness unless they are part of the chosen model correspondence or source assumptions. Explicitly distinguish an external condition on the graph interpretation from an axiom added to the theory text. Retain `Evaluate(z x)` for an atomic or variable expression as a separate relation; do not replace it with `z = x`.

The absence of a result is not Boolean `False`. In HOL, use `option` / `Option`, or an explicitly justified relational representation. Expand nested partial operations using intermediate values with correctly scoped quantifiers; do not replace them with total functions returning arbitrary values.

## 7. Language-specific rules

### 7.1. `rus` and `eng`

Convey the same formula: quantifiers, conditions, disjunctions, relation directions, argument order, and reconstruction status. Do not “correct” a semantically odd formula into a familiar arithmetic law. Compare both versions with each other and with the CycL syntax tree.

### 7.2. `fol`

Follow the supplied grammar rather than arbitrary mathematical notation. In the current version:

- Declarations have the forms `type Object primary.`, `pred P (Object Object) primary.`, and `const One Object primary.`.
- Predicate arguments have no commas: `P(v0 v1)`.
- Quantified variable lists use commas: `(∀ v0, v1 : Object FORMULA)`.
- An assertion has a label and a terminating period: `UnitID FORMULA.`.
- Do not add arbitrary grouping parentheses: the grammar enumerates specific parenthesized forms for connectives, equalities, and quantifiers.
- Declare all names and check arities separately from syntax: the grammar does not guarantee a correct interpretation of names.

Ordinary FOL does not permit a bound variable to serve as a function or predicate symbol. Syntactic acceptance of `ID(...)` does not remove this restriction. If such a direct translation is required, put a bilingual “not expressible in fol” / “не выразимо на fol” comment in `fol`, with a reason, without inventing `Apply` or supplying a fictitious formula.

### 7.3. `isb` — Isabelle/HOL

In the shared block, declare the theory, imports, abstract domain, and required constants and predicates. Distinguish names in the translated signature from library names, for example with the `Cyc` prefix.

By default, each unit contains `definition UnitID :: bool where ...`, defining **a proposition**, not an axiom asserting its truth and not a proof. For quantification over a partial binary operation, the type `cyc_value ⇒ cyc_value ⇒ cyc_value option` is permitted; mark the chosen typing and semantics as `interpretation-dependent` if they are not established directly by the source.

Do not insert `axiomatization`, fictitious proofs, or `sorry` to create an impression of verification. Explicitly identify a direct formalization that cannot be supplied.

### 7.4. `len` — Lean 4

Use an abstract domain and a `Signature` structure consistent with `isb`; definitions take parameter `S` and return `Prop`. Account for the universe level of the common domain. Numeric classes remain predicates.

A partial binary operation may have type `α → α → Option α`: `some v` is a result, and `none` is the absence of a result. Align the types of operation classifiers with this interpretation.

`def UnitID ... : Prop := ...` does not prove the proposition. Do not replace it with `axiom` or fill in proofs using `sorry`. State actual imports; do not assume mathlib is available unless needed.

### 7.5. `ofs` — OWL 2 DL, Direct Semantics

Declare local IRIs, classes, object properties, and named individuals. The common domain corresponds to `owl:Thing`. Do not replace object-level numeric classes with datatypes without separate justification.

Check **the particular formula**, not whether arithmetic could yield a similar conclusion. In particular:

- A general ternary predicate is not an OWL object property.
- Symmetry of a binary property does not mean exchanging two arguments of a ternary relation while keeping the third fixed.
- Transitivity of a relation is not associativity of a binary operation.
- `ObjectUnionOf` combines classes, not relation directions on an arbitrary pair of variables.
- Punning does not provide the required quantification over properties and does not automatically connect individual and predicate interpretations.
- Do not add domain, range, functionality, individual-distinctness, or value-existence restrictions merely to facilitate translation.

A binary slice such as `PlusToZero(x,y) <-> PlusValue(x,y,Zero)` is permitted only as an **explicitly declared** correspondence for the particular formula. It does not represent the full ternary graph and does not preserve its original arity. If the original arity is required without a slice, write “not expressible in ofs” / “не выразимо на ofs”.

Nonexpressible parts contain only bilingual comments giving a specific reason. Do not silently introduce reification, SWRL, an external evaluator, a nonstandard n-ary datatype, or stronger semantics.

When the ontology is assembled, translated records become **asserted axioms**. Including a reconstruction means assuming a hypothesis, not confirming or proving it.

### 7.6. `col` — Common Logic / CLIF

Preserve n-ary relations, evaluation graphs, equality, and quantifier scopes in a consistent single-sorted representation. Do not erase types and sorts without describing the correspondence. An example of CLIF notation is `(forall (v0) (if (P v0) (Q v0)))`.

Common Logic permits application of a bound variable in predicate position. However, its quantifier ranges over represented domain objects, **not automatically over every function in a full HOL function space**.

If `(f x y z)` is used as the graph of a partial binary operation, declare precisely this correspondence and state the required single-valuedness and strictness conditions. Distinguish model conditions from axioms actually included. Mark this change as `interpretation-dependent`, not as literal preservation of a binary function term. Do not silently introduce a universal `Apply` predicate.

If full HOL quantification over all partial functions is required and no direct translation into the selected CL representation preserves it, write “not expressible in col” / “не выразимо на col” with respect to that requirement. If needed, a separately qualified weaker or interpretation-dependent formalization may be given alongside it; this does not remove the limitation notice and must not be presented as an exact translation of the original requirement.

The assembled CL text asserts sentences; it does not prove them. Fixed arities stated in the translation conventions do not mean that Common Logic globally requires each name to have a single arity.

## 8. Recording limitations and validation

In a comment in the target language, state:

1. Exactly what cannot be translated or requires the chosen interpretation.
2. Which semantics and signature correspondence are adopted.
3. Which feature of the language prevents a direct translation.
4. Which encodings or strengthenings were deliberately not introduced.
5. Which tools were actually run and their results.

Distinguish `signature-relative` — a translation relative to a declared signature correspondence; `interpretation-dependent` — a formalization involving an additional interpretive choice; and `not machine-checked` — absence of tool-based verification. These labels are not synonyms and may be combined.

The phrase “not expressible in …” / “не выразимо на …” refers to the specified **direct representation**. Without a separate proof, do not claim that every possible encoding is impossible. An unavailable compiler or a syntax error in a translation does not by itself imply logical nonexpressibility.

## 9. Complete minimal example

The following is **an instructional example**, not a claim about the contents of an arbitrary microtheory and not the result of running compilers. For this example, assume it has been confirmed that line 1 of `ExampleMt.cycl` contains the following assertion belonging to that Mt:

```lisp
(#$relationAllInstance #$greaterThanOrEqualTo #$PositiveInteger 1)
```

Here, `relationAllInstance` is expanded according to an explicitly adopted meaning: for every member of the specified class, the relation holds between that member and the specified object. Other occurrences of this predicate require the same check of argument order.

The complete one-unit container follows. Its signatures are deliberately minimal. For an actual input, extend them and replace the metadata with actual values.

```text
format: multilingual-knowledge-units-1
microtheory: #$ExampleMt
microtheory-status: confirmed
encoding: UTF-8 with BOM; CRLF
source: ExampleMt.cycl
work-performed-by: Academia Co-scientist (AI research assistant).
how-to-invoke: Open Academia Co-scientist on Academia.edu and send a message in its chat; attach the source .cycl and this instruction.
fol-grammar: fol_lexer_min.g4 + fol_parser_min.g4
languages: cycl, rus, eng, fol, isb, len, ofs, col

[conventions]
rus:
Учебный пример с одной исходной формулой. Принадлежность ExampleMt предполагается подтверждённой условиями примера. Свободная v0 универсальна. Числовой класс — предикат общего непустого носителя, One — объектная константа, не встроенное число. GreaterThanOrEqualTo соответствует исходному greaterThanOrEqualTo; в isb/len используются имена с префиксом Cyc, в ofs — объектное свойство :greaterThanOrEqualTo. Арифметика и тотальность отношения не добавлены. isb/len определяют предложение; fol/ofs/col представляют его как утверждение при сборке. Проверка компиляторами, стандартными парсерами и доказателями не заявляется.
eng:
An instructional example with one original formula. Membership in ExampleMt is assumed confirmed by the example conditions. The free v0 is universally quantified. The numeric class is a predicate over a common nonempty domain; One is an object constant, not a built-in number. GreaterThanOrEqualTo corresponds to the source greaterThanOrEqualTo; isb/len use Cyc-prefixed names and ofs uses the object property :greaterThanOrEqualTo. No arithmetic or totality of the relation is added. isb/len define the proposition; fol/ofs/col present it as an assertion when assembled. No compiler, standard-parser, or prover verification is claimed.

[fol-signature]
type Object primary.
pred PositiveInteger (Object) primary.
pred GreaterThanOrEqualTo (Object Object) primary.
const One Object primary.
[/fol-signature]

[isb-signature]
theory ExampleMt_Translation
  imports Main
begin

typedecl cyc_value
consts
  CycPositiveInteger :: "cyc_value \<Rightarrow> bool"
  CycGreaterThanOrEqualTo :: "cyc_value \<Rightarrow> cyc_value \<Rightarrow> bool"
  CycOne :: cyc_value
[/isb-signature]

[len-signature]
import Init

namespace ExampleMtTranslation

universe u

structure Signature where
  Carrier : Type u
  CycOne : Carrier
  CycPositiveInteger : Carrier → Prop
  CycGreaterThanOrEqualTo : Carrier → Carrier → Prop
[/len-signature]

[ofs-signature]
Prefix(:=<urn:examplemt-translation:>)
Ontology(<urn:examplemt-translation:ontology>
Declaration(Class(:PositiveInteger))
Declaration(ObjectProperty(:greaterThanOrEqualTo))
Declaration(NamedIndividual(:One))
[/ofs-signature]

[col-signature]
(cl-text ExampleMt_Translation
[/col-signature]

[unit ExampleMt_L1]
cycl:
;; eng:
;; Source: ExampleMt.cycl, line 1; source status: original.

;; rus:
;; Источник: ExampleMt.cycl, строка 1; статус источника: original (исходная формула).
(#$relationAllInstance #$greaterThanOrEqualTo #$PositiveInteger 1)
rus:
Для любого v0: если v0 принадлежит классу положительных целых чисел, то отношение «больше или равно» выполнено для v0 и One.
eng:
For every v0: if v0 belongs to the class of positive integers, then the greater-than-or-equal relation holds between v0 and One.
fol:
ExampleMt_L1 (∀ v0 : Object (PositiveInteger(v0) → GreaterThanOrEqualTo(v0 One))).
isb:
(*
  eng:
  Signature-relative translation; proposition defined, not proved; not machine-checked.
*)
(*
  rus:
  Перевод относительно соответствия сигнатур; предложение определено, не доказано; машинная проверка не проводилась.
*)
definition ExampleMt_L1 :: bool where
  "ExampleMt_L1 \<longleftrightarrow>
    (\<forall>(v0 :: cyc_value). CycPositiveInteger v0 \<longrightarrow> CycGreaterThanOrEqualTo v0 CycOne)"
len:
/-
  eng:
  Signature-relative translation; proposition defined, not proved; not machine-checked.
-/
/-
  rus:
  Перевод относительно соответствия сигнатур; предложение определено, не доказано; машинная проверка не проводилась.
-/
def ExampleMt_L1 (S : Signature.{u}) : Prop :=
  ∀ (v0 : S.Carrier), S.CycPositiveInteger v0 → S.CycGreaterThanOrEqualTo v0 S.CycOne
ofs:
# eng:
# Signature-relative translation; an asserted OWL axiom, not a proof; not parser- or reasoner-checked.

# rus:
# Перевод относительно соответствия сигнатур; утверждаемая аксиома OWL, не доказательство; парсер и ризонер не запускались.
SubClassOf(:PositiveInteger ObjectHasValue(:greaterThanOrEqualTo :One))
col:
/*
  eng:
  Signature-relative translation; an asserted CL sentence, not a proof; not checked with a standard CLIF parser or prover.
*/
/*
  rus:
  Перевод относительно соответствия сигнатур; утверждаемое предложение CL, не доказательство; стандартный CLIF-парсер и доказатель не запускались.
*/
(forall (v0) (if (PositiveInteger v0) (GreaterThanOrEqualTo v0 One)))
[/unit ExampleMt_L1]

[isb-trailer]
end
[/isb-trailer]

[len-trailer]
end ExampleMtTranslation
[/len-trailer]

[ofs-trailer]
)
[/ofs-trailer]

[col-trailer]
)
[/col-trailer]

[provenance]
source-status: instructional-example
units: 1
original-units: 1
reconstructed-candidate-units: 0
unresolved-units: 0
external-tool-validation: not performed
```

Do not copy the example lines `source-status: instructional-example` and `external-tool-validation: not performed` into an actual result without checking that they apply. Nor should numerical totals from `MathMt.all` be copied: they apply only to that particular input.

## 10. Extracting target texts

`.all` is a container, **not a complete input for a compiler or logical parser**. Extract the contents of the parts, excluding container markers.

| Target | Assembly order |
|---|---|
| FOL | `fol-signature`, followed by all `fol` parts |
| Isabelle | `isb-signature`, all `isb` parts, `isb-trailer` |
| Lean | `len-signature`, all `len` parts, `len-trailer` |
| OWL | `ofs-signature`, all `ofs` parts, `ofs-trailer` |
| Common Logic | `col-signature`, all `col` parts, `col-trailer` |

Retain comments: a supporting target lexer skips them, and nonexpressibility notices contribute no logical formulas. If removing comments leaves no FOL declarations or formulas, note that the supplied parser's `text` rule requires at least one element.

The extractor must track native-comment and string states. Searching for any line `eng:` or `rus:` without accounting for comments is incorrect. A rule that treats any sequence of letters followed by a colon as a new part is insufficient. Do not include the header, `conventions`, `provenance`, or ancestor lists in the target code.

In Isabelle, the theory file name must match the `theory` name. Create separate `.thy`, `.lean`, `.ofn`, or `.clif` files as user-facing outputs only when requested; do not mix temporary validation files with source data.

## 11. Pre-delivery checks

### Container and source

- [ ] The source `.cycl` is unchanged; its name and hash correspond to the actual input bytes.
- [ ] Mt membership, export wrappers, and the boundaries of the Mt's own content are established or explicitly marked as assumed.
- [ ] Every selected formula has exactly one unit; malformed records, alternatives, and exclusions are accounted for.
- [ ] All IDs are unique; unit boundaries match; each unit has exactly eight language parts and no administrative labels.
- [ ] Substantive comments have corresponding `eng`/`rus` blocks; each language has one overall label in `conventions`.
- [ ] Source status, source-location references, and the selected formula text are preserved, with documented exceptions such as removal of an export wrapper.
- [ ] ASCII names, UTF-8 BOM, and CRLF are respected.

### Meaning and code

- [ ] Quantifiers, scopes, connectives, and arguments match; renaming does not capture variables.
- [ ] All names are declared or described as appropriate to the target language; arities and types agree; there are no accidental case mismatches.
- [ ] Signature changes and partial definedness are explained; missing values are not turned into `False`.
- [ ] No hidden arithmetic, functional, type-related, contextual, or other strengthening assumptions have been added.
- [ ] Each nonexpressible part gives a specific reason and identifies the adopted direct-translation approach.
- [ ] Proposition definitions, asserted axioms, hypotheses, and proofs are clearly distinguished.
- [ ] Assembly of target texts has been checked; unperformed checks are listed as unperformed.

Distinguish validation levels: **container structure → target-language syntax → types/global restrictions → translation correspondence → truth or proof**. Success at one level does not establish the next. In particular, parsing OWL does not guarantee compliance with every OWL 2 DL restriction, and acceptance of an Isabelle/Lean definition does not prove the proposition defined.

Run actual tools where possible and record their versions, commands or modes, and results. Describe a custom recognizer, formula-tree comparison, or finite-model test as precisely that. Such checks are useful but do not replace a standard parser, compiler, general equivalence proof, or nonexpressibility proof. Do not attribute to a new file the results of checks performed only on the earlier `MathMt.all`.

## 12. Sample task for the assistant

> Create `NameMt.all` from the attached `NameMt.cycl` according to these instructions. First establish microtheory membership, or explicitly mark it as assumed, and separate the Mt's own assertions from ancestors and administrative records. Preserve provenance, malformed records, and reconstruction statuses. For every selected formula, create exactly eight parts: cycl, rus, eng, fol, isb, len, ofs, col. Use the supplied grammars for fol; make every substantive comment bilingual within the language's native comments. Do not silently introduce encodings or stronger assumptions. Explicitly identify nonexpressibility of a direct translation and give the reason; distinguish interpretation-dependent formalizations from exact translations. Add shared signatures, closing blocks, and factual provenance. Save with UTF-8 BOM and CRLF. Do not modify the source. Perform available checks and separately list tools not run; do not present definitions as proofs.

## References

- The local `fol_lexer_min.g4` and `fol_parser_min.g4` are the mandatory syntax contract for `fol`.
- [OWL 2 Structural Specification and Functional-Style Syntax](https://www.w3.org/TR/2012/REC-owl2-syntax-20121211/) and [OWL 2 Direct Semantics](https://www.w3.org/TR/2012/REC-owl2-direct-semantics-20121211/).
- Common Logic: [ISO/IEC 24707:2007](https://www.iso.org/standard/39175.html), [ISO/IEC 24707:2018](https://www.iso.org/standard/66249.html), including the description of CLIF. The [CLIF implementation grammar](https://raw.githubusercontent.com/antlr/grammars-v4/master/clif/CLIF.g4) is a supplementary reference, not a normative substitute for the standard.
- Check Isabelle/HOL and Lean 4 syntax and libraries against documentation for the versions actually used.
