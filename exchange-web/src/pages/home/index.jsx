// LIBRARIES //
import React, { Fragment, useEffect, useState } from 'react';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';
import Divider from '@mui/material/Divider';

// COMPONENTS //
import CurrencyConversionForm from '../../components/CurrencyConversionForm';

const HomePage = () => {
    const [rateData, setRateData] = useState({});

    useEffect(() => {
        const fetchJson = {
            mode: 'cors',
            method: 'GET',
            headers: {
              'Content-Type': 'application/json',
            },
        };

        fetch('http://localhost:3000/all_rates', fetchJson)
        .then((response) => response.json())
        .then((jsonResp) => setRateData(jsonResp))
    }, []);

    const rateDataArray = Object.entries(rateData);

    return (
        <Fragment>
            <CurrencyConversionForm rateData={rateDataArray} />
            <Divider />
            <TableContainer component={Paper}>
                <Table aria-label="Conversions">
                    <TableHead>
                        <TableRow>
                            <TableCell>Currency</TableCell>
                            <TableCell>Conversion Rate</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {/** cut off at 100 so it doesnt make the page huge */}
                        {rateDataArray.slice(0, 100).map(([key, value]) => (
                            <TableRow>
                                <TableCell>{key}</TableCell>
                                <TableCell>{`$${value}`}</TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
            </TableContainer>
        </Fragment>
    );
}

export default HomePage;
