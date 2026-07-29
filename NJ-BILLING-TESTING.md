# Billing Flow Testing Checklist

Open items only. Fixed bugs and their postmortems now live as numbered rules in `CLAUDE.md` (search there before re-investigating something that looks like a repeat) or in `PROJECT.md`'s prose — not duplicated here. Status markers: **Not built** / **Built, untested** / **Claude-tested** / **Gabby-tested**.

## Entry point
| Item | Status |
|---|---|
| Nav "Billing" click → landing screen (2 options, toggle-dependent) | Built, untested |
| Dashboard "Run Billing" button → landing screen | Built, untested |
| Landing card visual style (match Reports page card layout) | Not built |

## Flow 1 — Direct (Alexandra, Queenstown, Direct)
Regression check only — pre-existing, unchanged by the Run Billing rework.
| Item | Status |
|---|---|
| Step 1 retailer dropdown / item table / date filter, Step 2 summary, Step 3 PDFs, Step 4 confirm | Built, untested |

## Flow 2 — Nationwide (Gabby bills Nationwide)
| Item | Status |
|---|---|
| Landing → "Nationwide" → Statement Builder directly, resumes an existing draft if one exists | Built, untested |
| Statement Builder: packet expander per invoice row | Built, untested |
| Generate Statement → Review & Finalize modal (Reprint / Void – Start Over / Finalize) | Built, untested |
| "View Statement History" link on landing screen | Built, untested |

## Flow 3 — Nationwide - Paula (Paula invoices Gabby for her NJ share)
| Item | Status |
|---|---|
| Locked item picker (NJ items where `paula_pct > 0`, no retailer dropdown) | Built, untested |
| Packet count + expandable packet list per sub-customer | Built, untested |
| Step 4 confirm + mark billed | Built, untested |

## NJ shipping markup (10%, covers Nationwide's 8.5% commission on shipping too)
| Item | Status |
|---|---|
| Shipment creation stores both `shipping_cost` (raw) and `shipping_cost_billed` (marked up) | Built, untested |
| Create-Shipment modal's live GST preview matches the marked-up figure | Built, untested |
| Shipping row labelled "Shipping +10%" for NJ | Built, untested |

## Statement formatting (per reference PDF)
| Item | Status |
|---|---|
| Credit note reference shows a date range instead of a real credit note number | Not built — needs proper numbering on `nj_credit_notes` |

Everything else in the original formatting pass (Month selector, eligibility cutoff, filename/title, statement columns, summary block, GST number, payment details footer) is Gabby-tested — see `PROJECT.md`'s "Nationwide Jewellers — Statement" section for current behavior.

## Known open issues (out of scope for the current rework)
- Paula discount-leak in `buildInvoiceSummary()` — her NJ share is under-calculated by the discount %. See `CLAUDE.md` rule 21. The **Nationwide Monthly Split (CSV)** report (`PROJECT.md` → Views/Screens → Reports) makes this visible per-packet without fixing it.
- `isRetailerCombined()` dead-code cleanup — cosmetic.
- Credit notes need a proper credit note number (like `INV-XXXX` for tax invoices) instead of a date-range reference.
