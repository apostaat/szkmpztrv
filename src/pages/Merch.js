import React, { useState } from 'react';
import './Merch.css';

const Merch = () => {
  const [selectedSize, setSelectedSize] = useState('');
  const [quantity, setQuantity] = useState(1);

  const sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  const price = 39.99;

  const handleOrder = () => {
    if (!selectedSize) {
      alert('please select a size');
      return;
    }

    const message = `I want to purchase ${quantity} of kofta ${selectedSize}`;
    const whatsappUrl = `https://wa.me/?text=${encodeURIComponent(message)}`;
    window.open(whatsappUrl, '_blank');
  };

  return (
    <div className="merch">
      <div className="container">
        <h1 className="page-title">merch</h1>
        
        <div className="merch-content">
          <div className="product-card">
            <div className="product-image">
              <img src="/merch/kofta.png" alt="kofta" />
            </div>
            
            <div className="product-info">
              <h2 className="product-name">kofta</h2>
              <p className="product-description">exclusive union of composers and electronic machines merchandise</p>
              
              <div className="product-price">
                <span className="price-amount">${price}</span>
              </div>
              
              <div className="product-options">
                <div className="size-selector">
                  <label htmlFor="size">size:</label>
                  <select 
                    id="size" 
                    value={selectedSize} 
                    onChange={(e) => setSelectedSize(e.target.value)}
                  >
                    <option value="">select size</option>
                    {sizes.map(size => (
                      <option key={size} value={size}>{size}</option>
                    ))}
                  </select>
                </div>
                
                <div className="quantity-selector">
                  <label htmlFor="quantity">quantity:</label>
                  <select 
                    id="quantity" 
                    value={quantity} 
                    onChange={(e) => setQuantity(parseInt(e.target.value))}
                  >
                    {[1, 2, 3, 4, 5].map(qty => (
                      <option key={qty} value={qty}>{qty}</option>
                    ))}
                  </select>
                </div>
              </div>
              
              <button 
                className="btn order-btn" 
                onClick={handleOrder}
                disabled={!selectedSize}
              >
                order via whatsapp
              </button>
              
              <div className="order-summary">
                <p>total: ${(price * quantity).toFixed(2)}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Merch;
