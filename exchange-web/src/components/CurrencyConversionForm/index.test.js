import React from 'react';
import { render } from '@testing-library/react';
import CurrencyConversionForm from './';

test('renders learn react link', () => {
  const { getByText } = render(<CurrencyConversionForm />);
  const buttonElement = getByText(/Submit/i);
  expect(buttonElement).toBeInTheDocument();
});
