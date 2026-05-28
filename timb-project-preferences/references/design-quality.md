# Design Quality Preferences

- `design.md` is important and should be treated as the repo's design contract.
- `design.md` should cover visual styling, typography, spacing, color, radius, motion, loading states, empty states, error states, accessibility, SEO/GEO, and implementation rules for agents.
- Use `make-interfaces-feel-better` when building UI components, reviewing frontend code, implementing motion, or polishing visual details.
- Accessibility is not optional: meaningful `aria-label`s where needed, keyboard navigation, visible focus states, semantic landmarks, reduced-motion handling, and minimum hit areas.
- Use `seo-geo` for public websites and product pages: metadata, JSON-LD/schema, sitemap/robots, indexing, AI-search visibility, and answer-first content structure.
- Next.js pages should have intentional metadata, Open Graph/Twitter card coverage where relevant, canonical URLs when needed, and descriptive alt text for meaningful images.
- UI should follow shadcn/ui and Tailwind conventions unless the project intentionally chose another design system.
