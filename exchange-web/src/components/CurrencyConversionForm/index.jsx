// LIBRARIES //
import React, { Fragment, useState } from 'react';
import Autocomplete from '@mui/material/Autocomplete';
import TextField from '@mui/material/TextField';
import Button from '@mui/material/Button';
import Divider from '@mui/material/Divider';

const CurrencyConversionForm = ({ rateData }) => {
    const [fromCurrency, setFromCurrency] = useState('');
    const [toCurrency, setToCurrency] = useState('');
    const [amount, setAmount] = useState(0);
    const [convertedAmount, setConvertedAmount] = useState({ conversion_rate: 0, conversion_result: 0 });

    const submit = () => {
        const fetchJson = {
            mode: 'cors',
            method: 'GET',
            headers: {
              'Content-Type': 'application/json',
            },
        };
        fetch(`http://localhost:3000/get_exchange_rate?${new URLSearchParams({ from_currency: fromCurrency, to_currency: toCurrency, amount })}`, fetchJson)
        .then((response) => response.json())
        .then((jsonResp) => setConvertedAmount(jsonResp))
    }

    const currencies = rateData && rateData.map((rate) => rate[0]);

    let message = `Converted Amount: $${convertedAmount.conversion_result}\nConvertion Rate: $${convertedAmount.conversion_rate}`;

    if (convertedAmount.message) {
        message = convertedAmount.message;
    }

    return (
        <Fragment>
            <Autocomplete
                sx={{ width: 300 }}
                options={currencies}
                renderInput={(params) => (
                    <TextField {...params} label="From Currency" variant="standard" />
                )}
                onChange={(_e, value) => setFromCurrency(value)}
            />
            <Autocomplete
                sx={{ width: 300 }}
                options={currencies}
                renderInput={(params) => (
                    <TextField {...params} label="To Currency" variant="standard" />
                )}
                onChange={(_e, value) => setToCurrency(value)}
            />
            <TextField label='Amount' variant='standard' onChange={(e) => setAmount(e.target.value)} />
            <Button onClick={submit}>Submit</Button>
            <Divider />
            <h1>{message}</h1>
        </Fragment>
    );
}

export default CurrencyConversionForm;
