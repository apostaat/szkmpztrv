# союз композиторов и эвм

**union of composers and electronic machines**

A React SPA showcasing the collaborative work of the Union of Composers and Electronic Machines collective.

## Features

- **Interactive Art**: p5.js sketch with animated waves and geometric patterns
- **Responsive Design**: Mobile-first approach with modern UI/UX
- **Team Showcase**: Member profiles with photos and information
- **Merchandise**: Product catalog with WhatsApp ordering integration
- **Manifest**: Collective philosophy and artistic vision
- **Events**: Upcoming events and performances

## Technology Stack

- **Frontend**: React 18, React Router DOM
- **Graphics**: p5.js for interactive art
- **Styling**: CSS3 with responsive design
- **Fonts**: Trafaret Kit for branding
- **Deployment**: Vultr with Nginx, CI/CD via GitHub Actions

## Getting Started

### Prerequisites

- Node.js 18.x or higher
- npm or yarn

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/szkmpztrv.git
cd szkmpztrv
```

2. Install dependencies:
```bash
npm install
```

3. Start development server:
```bash
npm start
```

4. Open [http://localhost:3000](http://localhost:3000) in your browser.

### Building for Production

```bash
npm run build
```

## Project Structure

```
src/
├── components/          # Reusable UI components
│   ├── Navigation.js   # Main navigation component
│   └── Navigation.css
├── pages/              # Page components
│   ├── Home.js         # Home page with p5.js sketch
│   ├── Manifest.js     # Collective manifest
│   ├── Team.js         # Team member profiles
│   ├── Events.js       # Events page
│   └── Merch.js        # Merchandise catalog
├── assets/             # Static assets
├── styles/             # Global styles
└── App.js              # Main application component
```

## Deployment

### Vultr Setup

1. Create a new Vultr instance (Ubuntu 22.04 recommended)
2. SSH into your server
3. Run the deployment script:
```bash
chmod +x deploy.sh
./deploy.sh
```

### GitHub Actions CI/CD

1. Add the following secrets to your GitHub repository:
   - `VULTR_HOST`: Your Vultr server IP
   - `VULTR_USERNAME`: SSH username (usually `root`)
   - `VULTR_SSH_KEY`: Your private SSH key
   - `VULTR_PORT`: SSH port (usually `22`)

2. Push to main/master branch to trigger automatic deployment

### Manual Deployment

```bash
npm run build
# Copy build/ folder to your server's web directory
```

## Customization

### Adding Team Members

1. Add member photo to `public/team/` (format: `username.jpg`)
2. Update member information in `src/pages/Team.js`
3. If no photo exists, a placeholder with the collective name will be shown

### Adding Merchandise

1. Add product images to `public/merch/`
2. Update product information in `src/pages/Merch.js`
3. Modify WhatsApp message format as needed

### Styling

- Global styles: `src/index.css`
- Component styles: Individual `.css` files
- Font customization: Update `@font-face` in `public/index.html`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is part of the Union of Composers and Electronic Machines collective.

## Contact

For questions or collaboration opportunities, reach out to the collective through the channels listed in the team section.
